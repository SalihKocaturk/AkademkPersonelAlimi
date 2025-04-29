import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proje1/domain/cubits/admin_cubit.dart';
import 'package:proje1/locator.dart';
import 'package:uuid/uuid.dart';
import 'package:proje1/models/announcment.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _docController = TextEditingController();
  final _positionController = TextEditingController();
  final _tabsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Paneli"),
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
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _showEditDialog(context, ann),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ann.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 12,
                                  children: [
                                    _infoBox("Kadrolar", ann.position),
                                    _infoBox("Başlangıç Tarihi", ann.startDate),
                                    _infoBox("Bitiş Tarihi", ann.endDate),
                                    _infoBox(
                                      "Gerekli Belgeler",
                                      ann.requiredDocuments.join(", "),
                                    ),
                                    _infoBox(
                                      "Kriter Sekmeleri",
                                      ann.criteriaTabs.join(", "),
                                    ),
                                    _infoBox("Açıklama", ann.description),
                                  ],
                                ),
                              ],
                            ),
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
                    _buildStyledField(
                      _positionController,
                      "Kadrolar (Prof., Doç., Dr.)",
                    ),
                    _buildStyledField(_startController, "Başlangıç Tarihi"),
                    _buildStyledField(_endController, "Bitiş Tarihi"),
                    _buildStyledField(
                      _docController,
                      "Gerekli Belgeler (virgülle ayır)",
                    ),
                    _buildStyledField(_tabsController, "Kriter Sekmeleri"),
                    _buildStyledField(_descController, "Açıklama", maxLines: 3),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          final newAnn = Announcement(
                            id: const Uuid().v4(),
                            title: _titleController.text,
                            position: _positionController.text,
                            startDate: _startController.text,
                            endDate: _endController.text,
                            requiredDocuments:
                                _docController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList(),
                            criteriaTabs:
                                _tabsController.text
                                    .split(',')
                                    .map((e) => e.trim())
                                    .toList(),
                            description: _descController.text,
                          );
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

  Widget _infoBox(String title, String value) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(value, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Announcement ann) {
    final titleController = TextEditingController(text: ann.title);
    final positionController = TextEditingController(text: ann.position);
    final startDateController = TextEditingController(text: ann.startDate);
    final endDateController = TextEditingController(text: ann.endDate);
    final documentsController = TextEditingController(
      text: ann.requiredDocuments.join(", "),
    );
    final tabsController = TextEditingController(
      text: ann.criteriaTabs.join(", "),
    );
    final descController = TextEditingController(text: ann.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("İlanı Düzenle"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "İlan Başlığı"),
                ),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(labelText: "Kadrolar"),
                ),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(
                    labelText: "Başlangıç Tarihi",
                  ),
                ),
                TextField(
                  controller: endDateController,
                  decoration: const InputDecoration(labelText: "Bitiş Tarihi"),
                ),
                TextField(
                  controller: documentsController,
                  decoration: const InputDecoration(
                    labelText: "Gerekli Belgeler",
                  ),
                ),
                TextField(
                  controller: tabsController,
                  decoration: const InputDecoration(
                    labelText: "Kriter Sekmeleri",
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Açıklama"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedAnn = ann.copyWith(
                  title: titleController.text,
                  position: positionController.text,
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                  requiredDocuments:
                      documentsController.text
                          .split(",")
                          .map((e) => e.trim())
                          .toList(),
                  criteriaTabs:
                      tabsController.text
                          .split(",")
                          .map((e) => e.trim())
                          .toList(),
                  description: descController.text,
                );
                getIt<AdminCubit>().updateAnnouncement(updatedAnn);
                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
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

  void _clearFields() {
    _titleController.clear();
    _descController.clear();
    _startController.clear();
    _endController.clear();
    _docController.clear();
    _positionController.clear();
    _tabsController.clear();
  }
}
