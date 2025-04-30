import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../domain/cubits/admin_cubit.dart';
import '../../locator.dart';
import '../../models/announcment1.dart';

class AdminHome extends StatefulWidget {
  AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _docController = TextEditingController();
  final _positionList = ["1", "2", "3"];
  final _temelAlanList = ["1", "2", "3", "4"];

  String? selectedPosition;
  String? selectedTemelAlan;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String kadroTipiToText(int id) {
    switch (id) {
      case 1:
        return "Dr. Öğr. Üyesi";
      case 2:
        return "Doçent";
      case 3:
        return "Profesör";
      default:
        return "Bilinmeyen";
    }
  }

  String temelAlanToText(int id) {
    switch (id) {
      case 1:
        return "Mühendislik";
      case 2:
        return "Fen Bilimleri ve Matematik";
      case 3:
        return "Sağlık Bilimleri";
      case 4:
        return "Sosyal, Beşeri ve İdari Bilimler";
      case 5:
        return "Güzel Sanatlar";
      default:
        return "Bilinmeyen";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Paneli"),
          actions: [
            IconButton(
              tooltip: "Aday Paneline Git",
              icon: const Icon(Icons.person),
              onPressed: () {
                context.go("/home/candidate");
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: "İlanları Görüntüle"),
              Tab(icon: Icon(Icons.add), text: "Yeni İlan Ekle"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<AdminCubit, AdminState>(
              bloc: getIt<AdminCubit>(),
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AdminLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.announcements.length,
                    itemBuilder: (context, index) {
                      final ann = state.announcements[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(ann.title),
                          subtitle: Text(
                            "${ann.startDate.toLocal().toString().split(' ')[0]} - ${ann.endDate.toLocal().toString().split(' ')[0]}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  _titleController.text = ann.title;
                                  _descController.text = ann.description;
                                  _docController.text = ann.requiredDocuments
                                      .join(", ");
                                  _startController.text =
                                      ann.startDate.toString().split(' ')[0];
                                  _endController.text =
                                      ann.endDate.toString().split(' ')[0];
                                  selectedPosition = ann.kadroTipiId.toString();
                                  selectedTemelAlan =
                                      ann.temelAlanId.toString();
                                  _selectedStartDate = ann.startDate;
                                  _selectedEndDate = ann.endDate;

                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text("İlanı Düzenle"),
                                          content: _buildEditForm(),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text("İptal"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                final updated = Announcement1(
                                                  id: ann.id,
                                                  title: _titleController.text,
                                                  description:
                                                      _descController.text,
                                                  kadroTipiId: int.parse(
                                                    selectedPosition!,
                                                  ),
                                                  temelAlanId: int.parse(
                                                    selectedTemelAlan!,
                                                  ),
                                                  startDate:
                                                      _selectedStartDate!,
                                                  endDate: _selectedEndDate!,
                                                  requiredDocuments:
                                                      _docController.text
                                                          .split(',')
                                                          .map((e) => e.trim())
                                                          .toList(),
                                                  olusturanAdminId: 1,
                                                  applicationConditions: '',
                                                );
                                                getIt<AdminCubit>()
                                                    .updateAnnouncement(
                                                      updated,
                                                    );
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Kaydet"),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => getIt<AdminCubit>()
                                        .deleteAnnouncement(ann.id.toString()),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text("Bir hata oluştu."));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStyledField(_titleController, "İlan Başlığı"),
                    _buildStyledField(_descController, "Açıklama", maxLines: 3),
                    _buildDateField(
                      context,
                      _startController,
                      "Başlangıç Tarihi",
                      isStart: true,
                    ),
                    _buildDateField(
                      context,
                      _endController,
                      "Bitiş Tarihi",
                      isStart: false,
                    ),
                    _buildStyledField(
                      _docController,
                      "Gerekli Belgeler (virgülle ayır)",
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown("Kadro Tipi Seçimi", _positionList, (value) {
                      selectedPosition = value;
                    }),
                    _buildDropdown("Temel Alan Seçimi", _temelAlanList, (
                      value,
                    ) {
                      selectedTemelAlan = value;
                    }),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          if (selectedPosition == null ||
                              selectedTemelAlan == null ||
                              _selectedStartDate == null ||
                              _selectedEndDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Lütfen tüm alanları doldurun!"),
                              ),
                            );
                            return;
                          }
                          final newAnn = Announcement1(
                            id: const Uuid().v4().hashCode,
                            title: _titleController.text,
                            description: _descController.text,
                            kadroTipiId: int.parse(selectedPosition!),
                            temelAlanId: int.parse(selectedTemelAlan!),
                            startDate: _selectedStartDate!,
                            endDate: _selectedEndDate!,
                            requiredDocuments:
                                _docController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList(),
                            olusturanAdminId: 1,
                            applicationConditions: '',
                          );
                          print(_titleController.text);
                          getIt<AdminCubit>().addAnnouncement(newAnn);
                          _clearFields();
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          "İlanı Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStyledField(_titleController, "İlan Başlığı"),
          const SizedBox(height: 8),
          _buildStyledField(_descController, "Açıklama", maxLines: 3),
          const SizedBox(height: 8),
          _buildDateField(
            context,
            _startController,
            "Başlangıç Tarihi",
            isStart: true,
          ),
          const SizedBox(height: 8),
          _buildDateField(
            context,
            _endController,
            "Bitiş Tarihi",
            isStart: false,
          ),
          const SizedBox(height: 8),
          _buildStyledField(
            _docController,
            "Gerekli Belgeler (virgülle ayırın)",
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            "Kadro Tipi Seçimi",
            _positionList,
            (val) => setState(() => selectedPosition = val),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            "Temel Alan Seçimi",
            _temelAlanList,
            (val) => setState(() => selectedTemelAlan = val),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStyledField(_titleController, "İlan Başlığı"),
        const SizedBox(height: 8),
        _buildStyledField(_descController, "Açıklama", maxLines: 3),
        const SizedBox(height: 8),
        _buildDateField(
          context,
          _startController,
          "Başlangıç Tarihi",
          isStart: true,
        ),
        const SizedBox(height: 8),
        _buildDateField(
          context,
          _endController,
          "Bitiş Tarihi",
          isStart: false,
        ),
        const SizedBox(height: 8),
        _buildStyledField(_docController, "Gerekli Belgeler (virgülle ayırın)"),
        const SizedBox(height: 8),
        _buildDropdown(
          "Kadro Tipi Seçimi",
          _positionList,
          (val) => setState(() => selectedPosition = val),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          "Temel Alan Seçimi",
          _temelAlanList,
          (val) => setState(() => selectedTemelAlan = val),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (selectedPosition == null ||
                  selectedTemelAlan == null ||
                  _selectedStartDate == null ||
                  _selectedEndDate == null)
                return;

              final newAnn = Announcement1(
                id: const Uuid().v4().hashCode,
                title: _titleController.text,
                description: _descController.text,
                kadroTipiId: int.parse(selectedPosition!),
                temelAlanId: int.parse(selectedTemelAlan!),
                startDate: _selectedStartDate!,
                endDate: _selectedEndDate!,
                requiredDocuments:
                    _docController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                olusturanAdminId: 1,
                applicationConditions: '',
              );

              getIt<AdminCubit>().addAnnouncement(newAnn);
              _clearFields();
            },
            child: const Text("İlanı Kaydet"),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    required bool isStart,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            setState(() {
              controller.text = date.toLocal().toString().split(' ')[0];
              if (isStart) {
                _selectedStartDate = date;
              } else {
                _selectedEndDate = date;
              }
            });
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items:
            items.map((e) {
              final id = int.parse(e);
              final displayText =
                  label.contains("Kadro")
                      ? kadroTipiToText(id)
                      : temelAlanToText(id);
              return DropdownMenuItem<String>(
                value: e,
                child: Text(displayText),
              );
            }).toList(),
        onChanged: onChanged,
        value: label.contains("Kadro") ? selectedPosition : selectedTemelAlan,
      ),
    );
  }

  void _clearFields() {
    _titleController.clear();
    _descController.clear();
    _startController.clear();
    _endController.clear();
    _docController.clear();
    selectedPosition = null;
    selectedTemelAlan = null;
    _selectedStartDate = null;
    _selectedEndDate = null;
  }
}
