import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/cubits/auth_cubit.dart';
import '../../domain/cubits/manager_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../models/yonetici_model.dart';

class ManagerHome extends StatelessWidget {
  // ignore: use_super_parameters
  const ManagerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManagerCubit(),
      child: const ManagerHomeBody(),
    );
  }
}

class ManagerHomeBody extends StatefulWidget {
  // ignore: use_super_parameters
  const ManagerHomeBody({Key? key}) : super(key: key);

  @override
  State<ManagerHomeBody> createState() => _ManagerHomeBodyState();
}

class _ManagerHomeBodyState extends State<ManagerHomeBody> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ManagerKriterEkrani(),
    const ManagerJuriAtamaEkrani(),
    const ManagerIlanIncelemeEkrani(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Kriter Belirleme',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Jüri Atama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'İlan İnceleme',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ManagerKriterEkrani extends StatefulWidget {
  // ignore: use_super_parameters
  const ManagerKriterEkrani({Key? key}) : super(key: key);

  @override
  State<ManagerKriterEkrani> createState() => _ManagerKriterEkraniState();
}

class _ManagerKriterEkraniState extends State<ManagerKriterEkrani> {
  @override
  void initState() {
    super.initState();
    context.read<ManagerCubit>().basvuruKriterYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kadro Kriterleri'),
        actions: [
              IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Çıkış Yap',
      onPressed: () {
        context.read<AuthCubit>().logout();
        context.go('/home'); // Ya da anasayfan neresiyse
      },
    ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final managerCubit = context.read<ManagerCubit>();
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return BlocProvider.value(
                    value: managerCubit,
                    child: const AddKadroKriterDialog(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ManagerCubit, YoneticiState>(
        builder: (context, state) {
          if (state is YoneticiKriterlerYukleniyor) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YoneticiBilgileriYuklendi) {
            if (state.kriterListesi.isEmpty) {
              return const Center(
                child: Text(
                  'Henüz kriter eklenmedi.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            final kriterListesi = state.kriterListesi;

            // Temel alanlara göre grupla
            final Map<String, List<KadroKriter>> alanGruplari = {};
            for (var kriter in kriterListesi) {
              alanGruplari.putIfAbsent(kriter.temelAlan, () => []);
              alanGruplari[kriter.temelAlan]!.add(kriter);
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children:
                  alanGruplari.entries.map((entry) {
                    final temelAlan = entry.key;
                    final kriterler = entry.value;

                    // Kadro türüne göre grupla
                    final Map<String, List<KadroKriter>> kadroGruplari = {};
                    for (var kriter in kriterler) {
                      kadroGruplari.putIfAbsent(kriter.kadroTuru, () => []);
                      kadroGruplari[kriter.kadroTuru]!.add(kriter);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          temelAlan,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...kadroGruplari.entries.map((kadroEntry) {
                          final kadroTuru = kadroEntry.key;
                          final kadroKriterList = kadroEntry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kadroTuru,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...kadroKriterList.map((kadro) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  elevation: 2,
                                  child: ListTile(
                                    title: Text(
                                      'Min Puan: ${kadro.minToplamPuan}',
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          kadro.kategoriKriterleri
                                              .map(
                                                (kategori) => Text(
                                                  '${kategori.kod}: Adet ${kategori.gerekliAdet}, Max Puan: ${kategori.maxPuan?.toString() ?? '-'}',
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            final cubit =
                                                context.read<ManagerCubit>();
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (_) => BlocProvider.value(
                                                    value: cubit,
                                                    child:
                                                        EditKadroKriterDialog(
                                                          kadroKriter: kadro,
                                                        ),
                                                  ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<ManagerCubit>()
                                                .kriterSunucudanSil(
                                                  kadro.kriterID,
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                        const Divider(thickness: 1.2),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
            );
          } else if (state is YoneticiHata) {
            return Center(child: Text(state.mesaj));
          }
          return const Center(child: Text('Herhangi bir giriş yapılmadı.'));
        },
      ),
    );
  }
}

class AddKadroKriterDialog extends StatefulWidget {
  // ignore: use_super_parameters
  const AddKadroKriterDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddKadroKriterDialogState createState() => _AddKadroKriterDialogState();
}

class _AddKadroKriterDialogState extends State<AddKadroKriterDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedKadroTuru;
  String? _selectedTemelAlan;

  final List<String> _kadroTuruOptions = [
    "Dr. Öğr. Üyesi",
    "Doçent",
    "Profesör",
  ];
  final List<String> _temelAlanOptions = [
    "Mühendislik",
    "Fen Bilimleri ve Matematik",
    "Sağlık Bilimleri",
    "Güzel Sanatlar",
  ];

  final TextEditingController _minToplamPuanController =
      TextEditingController();

  final List<String> _availableMakaleTypes = [
    "A1-A4",
    "A1-A5",
    "A1-A6",
    "A1-A8",
    "D1-D6",
    "E1-E4",
    "F1-F2",
    "H1-H17",
    "H1-H22",
    "K1-K11",
  ];

  late Map<String, bool> _makaleSelected;
  late Map<String, TextEditingController> _adetControllers;
  late Map<String, TextEditingController> _maxPuanControllers;

  @override
  void initState() {
    super.initState();
    _makaleSelected = {};
    _adetControllers = {};
    _maxPuanControllers = {};
    for (var type in _availableMakaleTypes) {
      _makaleSelected[type] = false;
      _adetControllers[type] = TextEditingController();
      _maxPuanControllers[type] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _minToplamPuanController.dispose();
    for (var controller in _adetControllers.values) {
      controller.dispose();
    }
    for (var controller in _maxPuanControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManagerCubit>();
    return AlertDialog(
      title: const Text('Yeni Kadro Kriteri Ekle'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedTemelAlan,
                  decoration: const InputDecoration(labelText: 'Temel Alan'),
                  items:
                      _temelAlanOptions
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => _selectedTemelAlan = val),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Lütfen temel alan seçin'
                              : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedKadroTuru,
                  decoration: const InputDecoration(labelText: 'Kadro Türü'),
                  items:
                      _kadroTuruOptions
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                  onChanged: (val) => setState(() => _selectedKadroTuru = val),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Lütfen kadro türünü seçin'
                              : null,
                ),
                TextFormField(
                  controller: _minToplamPuanController,
                  decoration: const InputDecoration(
                    labelText: 'Minimum Toplam Puan',
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Min toplam puan giriniz'
                              : null,
                ),
                const Divider(height: 30),
                const Text(
                  'Makale Kriteri Ekle',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Column(
                  children:
                      _availableMakaleTypes.map((type) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              title: Text(type),
                              value: _makaleSelected[type],
                              onChanged: (bool? newVal) {
                                setState(() {
                                  _makaleSelected[type] = newVal ?? false;
                                });
                              },
                            ),
                            if (_makaleSelected[type] == true)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 40.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _adetControllers[type],
                                        decoration: const InputDecoration(
                                          labelText: 'Gerekli Adet',
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (_makaleSelected[type] == true) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Adet giriniz';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _maxPuanControllers[type],
                                        decoration: const InputDecoration(
                                          labelText: 'Puan',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _selectedKadroTuru != null) {
              List<KategoriKriter> kategoriKriterleri = [];
              for (var type in _availableMakaleTypes) {
                if (_makaleSelected[type] == true) {
                  final adetStr = _adetControllers[type]?.text;
                  if (adetStr != null && adetStr.isNotEmpty) {
                    kategoriKriterleri.add(
                      KategoriKriter(
                        kod: type,
                        gerekliAdet: int.tryParse(adetStr) ?? 0,
                        minPuan: null,
                        maxPuan:
                            _maxPuanControllers[type]?.text.isNotEmpty == true
                                ? double.tryParse(
                                  _maxPuanControllers[type]!.text,
                                )
                                : null,
                      ),
                    );
                  }
                }
              }
              final kadro = KadroKriter(
                kriterID: 0,
                kadroTuru: _selectedKadroTuru!,
                temelAlan: _selectedTemelAlan!,
                minToplamPuan:
                    double.tryParse(_minToplamPuanController.text) ?? 0,
                kategoriKriterleri: kategoriKriterleri,
              );
              cubit.kriterSunucuyaEkle(kadro);
              Navigator.pop(context);
            }
            // ignore: prefer_interpolation_to_compose_strings
            debugPrint("Seçilen Alan" + _selectedTemelAlan.toString());
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class EditKadroKriterDialog extends StatefulWidget {
  final KadroKriter kadroKriter;

  // ignore: use_super_parameters
  const EditKadroKriterDialog({Key? key, required this.kadroKriter})
    : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditKadroKriterDialogState createState() => _EditKadroKriterDialogState();
}

class _EditKadroKriterDialogState extends State<EditKadroKriterDialog> {
  late String _selectedKadroTuru;
  late String _selectedTemelAlan;
  late TextEditingController _minToplamPuanController;

  @override
  void initState() {
    super.initState();
    _selectedKadroTuru = widget.kadroKriter.kadroTuru;
    _selectedTemelAlan = widget.kadroKriter.temelAlan;
    _minToplamPuanController = TextEditingController(
      text: widget.kadroKriter.minToplamPuan.toString(),
    );
  }

  @override
  void dispose() {
    _minToplamPuanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kadro Kriterini Düzenle'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedKadroTuru,
              decoration: const InputDecoration(labelText: 'Kadro Türü'),
              items:
                  ['Dr. Öğr. Üyesi', 'Doçent', 'Profesör']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) => setState(() => _selectedKadroTuru = val!),
            ),
            DropdownButtonFormField<String>(
              value: _selectedTemelAlan,
              decoration: const InputDecoration(labelText: 'Temel Alan'),
              items:
                  [
                        'Mühendislik',
                        'Fen Bilimleri ve Matematik',
                        'Sağlık Bilimleri',
                        'Güzel Sanatlar',
                      ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) => setState(() => _selectedTemelAlan = val!),
            ),
            TextFormField(
              controller: _minToplamPuanController,
              decoration: const InputDecoration(
                labelText: 'Minimum Toplam Puan',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            final yeniKadro = KadroKriter(
              kriterID: widget.kadroKriter.kriterID,
              kadroTuru: _selectedKadroTuru,
              temelAlan: _selectedTemelAlan,
              minToplamPuan:
                  double.tryParse(_minToplamPuanController.text) ?? 0,
              kategoriKriterleri:
                  widget
                      .kadroKriter
                      .kategoriKriterleri,
            );
            context.read<ManagerCubit>().kriterSunucudaGuncelle(
              yeniKadro,
              widget.kadroKriter.kriterID,
            );
            Navigator.pop(context);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class ManagerBasvuruDurumuEkrani extends StatelessWidget {
  // ignore: use_super_parameters
  const ManagerBasvuruDurumuEkrani({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '📊 Başvuru Durumu Sayfası (Devam edecek)',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class ManagerIlanIncelemeEkrani extends StatefulWidget {
  // ignore: use_super_parameters
  const ManagerIlanIncelemeEkrani({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ManagerIlanIncelemeEkraniState createState() =>
      _ManagerIlanIncelemeEkraniState();
}

class _ManagerIlanIncelemeEkraniState extends State<ManagerIlanIncelemeEkrani> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ManagerCubit>().basvuruKriterYukle();
    });
  }

  Widget _buildDecisionDialogContent(Basvuru basvuru) {
    String? selectedDecision = basvuru.durum;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Nihai Kararı Belirle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Onaylandı'),
                value: 'Onaylandı',
                groupValue: selectedDecision,
                onChanged: (value) {
                  setState(() {
                    selectedDecision = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Reddedildi'),
                value: 'Reddedildi',
                groupValue: selectedDecision,
                onChanged: (value) {
                  setState(() {
                    selectedDecision = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedDecision != null) {
                  context.read<ManagerCubit>().basvuruDurumGuncelle(
                    basvuru.basvuruID,
                    selectedDecision!,
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _showDecisionDialog(Basvuru basvuru) {
    final cubit = context.read<ManagerCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: _buildDecisionDialogContent(basvuru),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İlan İnceleme')),
      body: BlocBuilder<ManagerCubit, YoneticiState>(
        builder: (context, state) {
          if (state is YoneticiBasvurularYukleniyor) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YoneticiBilgileriYuklendi) {
            final basvurular = state.basvurular;
            if (basvurular.isEmpty) {
              return const Center(child: Text('Henüz başvuru yapılmadı.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: basvurular.length,
              itemBuilder: (context, index) {
                final basvuru = basvurular[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${basvuru.adayAdSoyad} - ${basvuru.ilanBaslik}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Başvuru Tarihi: ${basvuru.basvuruTarihi}'),
                        Text(
                          'İlan Süresi: ${basvuru.baslangicTarihi} - ${basvuru.bitisTarihi}',
                        ),
                        Text('Durum: ${basvuru.durum}'),
                        Text('Toplam Puan: ${basvuru.toplamPuan}'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Şimdilik sadece dosya varmış gibi gösteriyoruz
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('PDF dosyası indiriliyor...'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('PDF İndir'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _showDecisionDialog(basvuru),
                              icon: const Icon(Icons.check),
                              label: const Text('Nihai Karar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is YoneticiHata) {
            return Center(child: Text(state.mesaj));
          } else {
            return const Center(child: Text('Veri bulunamadı.'));
          }
        },
      ),
    );
  }
}

class ManagerJuriAtamaEkrani extends StatefulWidget {
  // ignore: use_super_parameters
  const ManagerJuriAtamaEkrani({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ManagerJuriAtamaEkraniState createState() => _ManagerJuriAtamaEkraniState();
}

class _ManagerJuriAtamaEkraniState extends State<ManagerJuriAtamaEkrani> {
List<List<String?>> selectedMembers = List.generate(100, (_) => List.filled(5, null));

  @override
  void initState() {
    super.initState();
    context.read<ManagerCubit>().basvuruKriterYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jüri Atamaları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final managerCubit = context.read<ManagerCubit>();
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return BlocProvider.value(
                    value: managerCubit,
                    child: const AddKadroKriterDialog(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ManagerCubit, YoneticiState>(
        builder: (context, state) {
          if (state is YoneticiKriterlerYukleniyor) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YoneticiBilgileriYuklendi) {
            if (state.kriterListesi.isEmpty) {
              return const Center(
                child: Text(
                  'Henüz kriter eklenmedi.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.juriIlanListesi.length,
              itemBuilder: (context, index) {
                final juriIlan = state.juriIlanListesi[index];
                // Initialize the selected member for this ilan if it doesn't exist
                if (selectedMembers.length <= index) {
                  selectedMembers.add(List.filled(5, null));
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          juriIlan.baslik,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Açıklama: ${juriIlan.aciklama}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text('Başlangıç Tarihi: ${juriIlan.baslangicTarihi}'),
                        Text('Bitiş Tarihi: ${juriIlan.bitisTarihi}'),
                        const SizedBox(height: 16),

                        // 🔁 5 Jüri Dropdown
                        Column(
                          children: List.generate(5, (juriIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jüri ${juriIndex + 1}'),
                                DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text('Üye Seçin'),
                                  value: selectedMembers[index][juriIndex],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMembers[index][juriIndex] =
                                          newValue;
                                    });
                                  },
                                  items:
                                      state.juriKullaniciListesi.map((
                                        juriKullanici,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: juriKullanici.juriAdSoyad,
                                          child: Text(
                                            '${juriKullanici.juriAdSoyad} (${juriKullanici.tcKimlik})',
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 16),

                        // ⏺️ Ata Butonu
                        ElevatedButton(
                          onPressed: () {
                            final cubit = context.read<ManagerCubit>();

                            for (int j = 0; j < 5; j++) {
                              final juriAdSoyad = selectedMembers[index][j];
                              if (juriAdSoyad != null) {
                                final juri = state.juriKullaniciListesi
                                    .firstWhere(
                                      (element) =>
                                          element.juriAdSoyad == juriAdSoyad,
                                    );

                                final atamaModel = JuriAtamaModel(
                                  ilanID: juriIlan.ilanID,
                                  tcKimlikNo: juri.tcKimlik,
                                );

                                cubit.juriAta(atamaModel);
                              }
                            }
                          },
                          child: const Text('5 Jüriyi Ata'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is YoneticiHata) {
            return Center(child: Text(state.mesaj));
          }
          return const Center(child: Text('Herhangi bir giriş yapılmadı.'));
        },
      ),
    );
  }
}
