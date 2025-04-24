import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/yonetici_cubit.dart';
import '../cubits/yonetici_state.dart';
import '../models/yonetici_model.dart';

class YoneticiPanelEkrani extends StatefulWidget {
  const YoneticiPanelEkrani({super.key});

  @override
  State<YoneticiPanelEkrani> createState() => _YoneticiPanelEkraniState();
}

class MockAday {
  final String adSoyad;
  final String kadroTuru;
  final double toplamPuan;
  final List<Map<String, dynamic>> belgeler;

  MockAday({
    required this.adSoyad,
    required this.kadroTuru,
    required this.toplamPuan,
    required this.belgeler,
  });
}

final mockAday = MockAday(
  adSoyad: 'Dr. Ahmet Yılmaz',
  kadroTuru: 'Doçent',
  toplamPuan: 138.0,
  belgeler: [
    {'kategori': 'A.1', 'puan': 30.0},
    {'kategori': 'A.2', 'puan': 15.0},
    {'kategori': 'B.1', 'puan': 20.0},
    {'kategori': 'E.1', 'puan': 10.0},
  ],
);

final List<String> eksikKategoriler = ['A.6', 'K.1', 'K.4'];

Widget buildAdayDegerlendirme() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(thickness: 2),
      const SizedBox(height: 16),
      const Text('🧑‍🎓 Aday Başvuru Değerlendirme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

      const SizedBox(height: 12),
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('👤 ${mockAday.adSoyad}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('🧾 Kadro Türü: ${mockAday.kadroTuru}'),
              Text('📊 Toplam Puan: ${mockAday.toplamPuan}'),
              const SizedBox(height: 16),

              const Text('✅ Yüklenen Belgeler:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...mockAday.belgeler.map((belge) => ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(belge['kategori']),
                trailing: Text('${belge['puan']} puan'),
              )),

              const SizedBox(height: 12),
              const Text('⚠️ Eksik Kategoriler:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              Wrap(
                spacing: 8,
                children: eksikKategoriler.map((k) => Chip(
                  label: Text(k),
                  backgroundColor: Colors.red.shade100,
                  labelStyle: const TextStyle(color: Colors.red),
                )).toList(),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // ignore: avoid_print
                      print("PDF çıktı alındı (Mock)");
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Tablo 5 PDF'),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          // ignore: avoid_print
                          print("Aday kabul edildi (Mock)");
                        },
                        child: const Text('Kabul'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          // ignore: avoid_print
                          print("Aday reddedildi (Mock)");
                        },
                        child: const Text('Red'),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ],
  );
}


class _YoneticiPanelEkraniState extends State<YoneticiPanelEkrani> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _minPuanController = TextEditingController();

  String _kadroTuru = 'Doçent';
  String _aktifIlanId = '';
  String _tc = '', _adSoyad = '', _unvan = '', _kurum = '';

  final Map<String, KategoriKriter> kategoriGirdileri = {};
  final List<String> kategoriKodlari = [
    'A.1', 'A.2', 'A.3', 'A.4', 'A.5', 'A.6',
    'B.1', 'B.2', 'C.1', 'C.2', 'D.1', 'D.2',
    'E.1', 'E.2', 'F.1', 'F.2', 'G.1', 'H.1',
    'I.1', 'K.1', 'K.2', 'K.3', 'K.4', 'K.5', 'K.6',
    'K.7', 'K.8', 'K.9', 'K.10', 'K.11',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetici Paneli')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('📌 Kadro Kriter Tanımı', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _kadroTuru,
                decoration: const InputDecoration(
                  labelText: 'Kadro Türü',
                  border: OutlineInputBorder(),
                ),
                items: ['Dr. Öğr. Üyesi', 'Doçent', 'Profesör']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _kadroTuru = val!),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _minPuanController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Toplam Puan',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  final v = double.tryParse(val ?? '');
                  return (v == null || v <= 0) ? 'Geçerli bir puan girin' : null;
                },
              ),
              const SizedBox(height: 16),

              const Text('Kategori Kriterleri', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              ...kategoriKodlari.map((kod) => Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(child: Text(kod)),
                      Checkbox(
                        value: kategoriGirdileri[kod]?.zorunluMu ?? false,
                        onChanged: (val) {
                          setState(() {
                            kategoriGirdileri[kod] = (kategoriGirdileri[kod] ??
                              KategoriKriter(kod: kod, gerekliAdet: 0, zorunluMu: false)
                            ).copyWith(zorunluMu: val ?? false);
                          });
                        },
                      ),
                      const Text('Zorunlu'),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          initialValue: kategoriGirdileri[kod]?.gerekliAdet.toString() ?? '0',
                          decoration: const InputDecoration(labelText: 'Adet'),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            setState(() {
                              kategoriGirdileri[kod] = (kategoriGirdileri[kod] ??
                                KategoriKriter(kod: kod, gerekliAdet: 0, zorunluMu: false)
                              ).copyWith(gerekliAdet: int.tryParse(val) ?? 0);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final kriter = KadroKriter(
                      kadroTuru: _kadroTuru,
                      kategoriKriterleri: kategoriGirdileri.values.toList(),
                      minToplamPuan: double.tryParse(_minPuanController.text) ?? 0,
                    );
                    context.read<YoneticiCubit>().kriterEkle(kriter);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kriter başarıyla kaydedildi.')),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Kriteri Kaydet'),
              ),

              const Divider(thickness: 2),
              const SizedBox(height: 16),

              const Text('👨‍⚖️ Jüri Atama Paneli', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'İlan ID',
                          prefixIcon: Icon(Icons.article_outlined),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => _aktifIlanId = val,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'TC Kimlik',
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => _tc = val,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Ad Soyad',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => _adSoyad = val,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Unvan',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => _unvan = val,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Kurum',
                          prefixIcon: Icon(Icons.apartment),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) => _kurum = val,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Jüri Ekle'),
                          onPressed: () {
                            if (_aktifIlanId.trim().isEmpty || _tc.trim().isEmpty) return;
                            final yeniJuri = JuriUyesi(
                              tcKimlik: _tc,
                              adSoyad: _adSoyad,
                              unvan: _unvan,
                              kurum: _kurum,
                            );
                            context.read<YoneticiCubit>().juriEkle(_aktifIlanId.trim(), yeniJuri);
                            setState(() {
                              _tc = '';
                              _adSoyad = '';
                              _unvan = '';
                              _kurum = '';
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text('🧾 Atanmış Jüriler', style: TextStyle(fontWeight: FontWeight.bold)),
              BlocBuilder<YoneticiCubit, YoneticiState>(
                builder: (context, state) {
                  final juriler = context.read<YoneticiCubit>().getJuriListesi(_aktifIlanId.trim());
                  if (juriler.isEmpty) return const Text('Henüz jüri atanmadı.');
                  return Column(
                    children: juriler.map((j) => Card(
                      child: ListTile(
                        title: Text(j.adSoyad),
                        subtitle: Text('${j.unvan} - ${j.kurum}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                          onPressed: () {
                            context.read<YoneticiCubit>().juriSil(_aktifIlanId.trim(), j.tcKimlik);
                          },
                        ),
                      ),
                    )).toList(),
                  );
                },
                
              ),
              buildAdayDegerlendirme(),
            ],
          ),
        ),
      ),
    );
  }
}
