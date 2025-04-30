import 'package:flutter/material.dart';
import 'package:proje1/service/generate_pdf.dart';

class CandidateApplication extends StatefulWidget {
  final String adSoyad;
  final String ilanBaslik;

  const CandidateApplication({
    required this.adSoyad,
    required this.ilanBaslik,
    super.key,
  });

  @override
  State<CandidateApplication> createState() => _CandidateApplicationState();
}

class _CandidateApplicationState extends State<CandidateApplication> {
  final List<Map<String, dynamic>> faaliyetler = [];
  int toplamPuan = 0;

  final Map<String, int> sabitPuanlar = {
    'Bildiri': 8,
    'Kitap': 10,
    'Atıf': 5,
    'Proje': 20,
    'Eğitim': 12,
    'İdari Görev': 15,
    'Sanat': 18,
    'Ödül': 25,
  };

  void _faaliyetEkleDialog() async {
    String? secilenTip;
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Faaliyet Tipi Seçin'),
            content: DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items:
                  [
                        'Makale',
                        'Bildiri',
                        'Kitap',
                        'Atıf',
                        'Proje',
                        'Eğitim',
                        'İdari Görev',
                        'Sanat',
                        'Ödül',
                      ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (val) => secilenTip = val,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (secilenTip != null) _faaliyetDetayDialog(secilenTip!);
                },
                child: const Text('İleri'),
              ),
            ],
          ),
    );
  }

  void _faaliyetDetayDialog(String tip) async {
    final TextEditingController aciklamaController = TextEditingController();
    final TextEditingController kisiSayisiController = TextEditingController();
    String? kategori;
    bool baslicaYazar = false;
    final Map<String, dynamic> detay = {};

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('$tip Ekle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tip == 'Makale') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Makale Tipi',
                      ),
                      items:
                          ['Q1', 'Q2', 'Q3', 'Q4', 'ESCI', 'Scopus', 'TR Dizin']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => kategori = val,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: kisiSayisiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Kişi Sayısı',
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text('Başlıca Yazarım'),
                      value: baslicaYazar,
                      onChanged:
                          (val) => setState(() => baslicaYazar = val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ] else if (tip == 'Bildiri') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Düzey'),
                      items:
                          ['Uluslararası', 'Ulusal']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['duzey'] = val,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Tür'),
                      items:
                          ['Sözlü', 'Poster']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['tur'] = val,
                    ),
                  ] else if (tip == 'Kitap') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Kitap Türü',
                      ),
                      items:
                          ['Kitap', 'Kitap Bölümü', 'Editörlük']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['kitapTuru'] = val,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Düzey'),
                      items:
                          ['Uluslararası', 'Ulusal']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['duzey'] = val,
                    ),
                  ] else if (tip == 'Proje') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Proje Türü',
                      ),
                      items:
                          [
                                'AB Projesi',
                                'TÜBİTAK 1001',
                                'TÜBİTAK 3001',
                                'BAP',
                                'Sanayi İşbirliği',
                                'Diğer',
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['projeTuru'] = val,
                    ),
                  ] else if (tip == 'Atıf') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Dergi Türü',
                      ),
                      items:
                          ['SCI-E', 'ESCI', 'Scopus', 'TR Dizin', 'Diğer']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['dergiTuru'] = val,
                    ),
                  ] else if (tip == 'Eğitim') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Ders Türü'),
                      items:
                          [
                                'Lisans Dersi',
                                'Yüksek Lisans Dersi',
                                'Tezsiz YL Dersi',
                                'Hazırlık/Yabancı Dil',
                                'Diğer',
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['dersTuru'] = val,
                    ),
                  ] else if (tip == 'İdari Görev') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Görev Türü',
                      ),
                      items:
                          [
                                'Rektör / Rektör Yardımcısı',
                                'Dekan / Dekan Yardımcısı',
                                'Enstitü / MYO Müdürü',
                                'Bölüm / Anabilim Dalı Başkanı',
                                'Komisyon / Koordinatörlük',
                                'Diğer',
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['gorevTuru'] = val,
                    ),
                  ] else if (tip == 'Sanat') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Etkinlik Türü',
                      ),
                      items:
                          [
                                'Uluslararası Sergi / Gösteri',
                                'Ulusal Sergi / Gösteri',
                                'Sanatsal Yarışma Katılımı',
                                'Sanatsal Ödül',
                                'Festival / Etkinlik Katılımı',
                                'Diğer',
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['sanatTuru'] = val,
                    ),
                  ] else if (tip == 'Ödül') ...[
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Ödül Türü'),
                      items:
                          [
                                'TÜBİTAK Ödülü',
                                'TÜBA Ödülü',
                                'Uluslararası Bilim / Sanat Ödülü',
                                'Ulusal Bilim / Sanat Ödülü',
                                'Üniversite Ödülü',
                                'Diğer',
                              ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => detay['odulTuru'] = val,
                    ),
                  ] else ...[
                    TextField(
                      controller: aciklamaController,
                      decoration: const InputDecoration(
                        labelText: 'Faaliyet Açıklaması',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    if (tip == 'Makale' &&
                        kategori != null &&
                        kisiSayisiController.text.isNotEmpty) {
                      final kisiSayisi =
                          int.tryParse(kisiSayisiController.text) ?? 1;
                      final puan = _makalePuanHesapla(
                        kategori!,
                        kisiSayisi,
                        baslicaYazar,
                      );
                      faaliyetler.add({
                        'tip': 'Makale - $kategori',
                        'puan': puan,
                      });
                    } else if (tip == 'Bildiri' &&
                        detay['duzey'] != null &&
                        detay['tur'] != null) {
                      final puan = _bildiriPuanHesapla(
                        detay['duzey'],
                        detay['tur'],
                      );
                      faaliyetler.add({
                        'tip': 'Bildiri - ${detay['duzey']} - ${detay['tur']}',
                        'puan': puan,
                      });
                    } else if (tip == 'Kitap' &&
                        detay['kitapTuru'] != null &&
                        detay['duzey'] != null) {
                      final puan = _kitapPuanHesapla(
                        detay['kitapTuru'],
                        detay['duzey'],
                      );
                      faaliyetler.add({
                        'tip':
                            'Kitap - ${detay['kitapTuru']} - ${detay['duzey']}',
                        'puan': puan,
                      });
                    } else if (tip == 'Proje' && detay['projeTuru'] != null) {
                      final puan = _projePuanHesapla(detay['projeTuru']);
                      faaliyetler.add({
                        'tip': 'Proje - ${detay['projeTuru']}',
                        'puan': puan,
                      });
                    } else if (tip == 'Atıf' && detay['dergiTuru'] != null) {
                      final puan = _atifPuanHesapla(detay['dergiTuru']);
                      faaliyetler.add({
                        'tip': 'Atıf - ${detay['dergiTuru']}',
                        'puan': puan,
                      });
                    } else if (tip == 'Eğitim' && detay['dersTuru'] != null) {
                      final puan = _egitimPuanHesapla(detay['dersTuru']);
                      faaliyetler.add({
                        'tip': 'Eğitim - ${detay['dersTuru']}',
                        'puan': puan,
                      });
                    } else if (tip == 'İdari Görev' &&
                        detay['gorevTuru'] != null) {
                      final puan = _idariGorevPuanHesapla(detay['gorevTuru']);
                      faaliyetler.add({
                        'tip': 'İdari Görev - ${detay['gorevTuru']}',
                        'puan': puan,
                      });
                    } else if (tip == 'Sanat' && detay['sanatTuru'] != null) {
                      final puan = _sanatPuanHesapla(detay['sanatTuru']);
                      faaliyetler.add({
                        'tip': 'Sanat - ${detay['sanatTuru']}',
                        'puan': puan,
                      });
                    } else if (tip == 'Ödül' && detay['odulTuru'] != null) {
                      final puan = _odulPuanHesapla(detay['odulTuru']);
                      faaliyetler.add({
                        'tip': 'Ödül - ${detay['odulTuru']}',
                        'puan': puan,
                      });
                    } else {
                      final puan = sabitPuanlar[tip] ?? 0;
                      faaliyetler.add({
                        'tip': tip,
                        'aciklama': aciklamaController.text,
                        'puan': puan,
                      });
                    }
                    _puanHesapla();
                  });
                },
                child: const Text('Ekle'),
              ),
            ],
          ),
    );
  }

  int _odulPuanHesapla(String tur) {
    switch (tur) {
      case 'TÜBİTAK Ödülü':
        return 30;
      case 'TÜBA Ödülü':
        return 28;
      case 'Uluslararası Bilim / Sanat Ödülü':
        return 25;
      case 'Ulusal Bilim / Sanat Ödülü':
        return 20;
      case 'Üniversite Ödülü':
        return 15;
      case 'Diğer':
      default:
        return 10;
    }
  }

  int _sanatPuanHesapla(String tur) {
    switch (tur) {
      case 'Uluslararası Sergi / Gösteri':
        return 25;
      case 'Ulusal Sergi / Gösteri':
        return 20;
      case 'Sanatsal Yarışma Katılımı':
        return 15;
      case 'Sanatsal Ödül':
        return 18;
      case 'Festival / Etkinlik Katılımı':
        return 10;
      case 'Diğer':
      default:
        return 5;
    }
  }

  int _egitimPuanHesapla(String tur) {
    switch (tur) {
      case 'Lisans Dersi':
        return 10;
      case 'Yüksek Lisans Dersi':
        return 12;
      case 'Tezsiz YL Dersi':
        return 8;
      case 'Hazırlık/Yabancı Dil':
        return 15;
      case 'Diğer':
      default:
        return 5;
    }
  }

  int _idariGorevPuanHesapla(String gorev) {
    switch (gorev) {
      case 'Rektör / Rektör Yardımcısı':
        return 30;
      case 'Dekan / Dekan Yardımcısı':
        return 25;
      case 'Enstitü / MYO Müdürü':
        return 20;
      case 'Bölüm / Anabilim Dalı Başkanı':
        return 15;
      case 'Komisyon / Koordinatörlük':
        return 10;
      case 'Diğer':
      default:
        return 5;
    }
  }

  int _atifPuanHesapla(String dergi) {
    switch (dergi) {
      case 'SCI-E':
        return 10;
      case 'ESCI':
        return 8;
      case 'Scopus':
        return 6;
      case 'TR Dizin':
        return 4;
      case 'Diğer':
      default:
        return 2;
    }
  }

  int _projePuanHesapla(String tur) {
    switch (tur) {
      case 'AB Projesi':
        return 30;
      case 'TÜBİTAK 1001':
        return 25;
      case 'TÜBİTAK 3001':
        return 20;
      case 'BAP':
        return 15;
      case 'Sanayi İşbirliği':
        return 18;
      case 'Diğer':
      default:
        return 10;
    }
  }

  int _makalePuanHesapla(String kategori, int kisiSayisi, bool baslica) {
    Map<String, int> temelPuanlar = {
      'Q1': 60,
      'Q2': 55,
      'Q3': 40,
      'Q4': 30,
      'ESCI': 25,
      'Scopus': 20,
      'TR Dizin': 10,
    };

    double kCarpan;
    if (kisiSayisi == 1) {
      kCarpan = 1.0;
    } else if (kisiSayisi == 2) {
      kCarpan = 0.8;
    } else if (kisiSayisi == 3) {
      kCarpan = 0.6;
    } else if (kisiSayisi == 4) {
      kCarpan = 0.5;
    } else if (kisiSayisi >= 5 && kisiSayisi <= 9) {
      kCarpan = 1 / kisiSayisi;
    } else {
      kCarpan = 0.1;
    }

    int puan = temelPuanlar[kategori] ?? 0;
    double hesap = puan * kCarpan;

    if (baslica) {
      hesap *= 1.8;
    }

    return hesap.round();
  }

  void _puanHesapla() {
    toplamPuan = faaliyetler.fold(
      0,
      (sum, item) => sum + (item['puan'] as int),
    );
  }

  int _bildiriPuanHesapla(String duzey, String tur) {
    if (duzey == 'Uluslararası') {
      return tur == 'Sözlü' ? 10 : 8;
    } else {
      return tur == 'Sözlü' ? 6 : 4;
    }
  }

  int _kitapPuanHesapla(String kitapTuru, String duzey) {
    if (kitapTuru == 'Kitap') {
      return duzey == 'Uluslararası' ? 40 : 30;
    } else if (kitapTuru == 'Kitap Bölümü') {
      return duzey == 'Uluslararası' ? 20 : 15;
    } else {
      return 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablo 5 Formu')),
      floatingActionButton: FloatingActionButton(
        onPressed: _faaliyetEkleDialog,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ad Soyad: ${widget.adSoyad}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'İlan Başlığı: ${widget.ilanBaslik}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faaliyetler.length,
              itemBuilder: (context, index) {
                final item = faaliyetler[index];
                return ListTile(
                  title: Text(item['tip']),
                  subtitle: Text('Puan: ${item['puan']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        faaliyetler.removeAt(index);
                        _puanHesapla();
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Toplam Puan: $toplamPuan',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  generateFullTablo5Pdf();
                  // PDF/Excel export burada olacak
                },
                child: const Text('TAMAMLA ve PDF/Excel Oluştur'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
