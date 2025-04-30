class JuriBasvuru {
  final int? basvuruID;
  final int? ilanID;
  final int? juriUyesiID;
  final String adayAd;
  final String adaySoyad;
  final String ilanBaslik;
  final String durum;
  final double? toplamPuan;
  final DateTime? basvuruTarihi;

  JuriBasvuru({
    required this.basvuruID,
    required this.ilanID,
    required this.juriUyesiID,
    required this.adayAd,
    required this.adaySoyad,
    required this.ilanBaslik,
    required this.durum,
    this.toplamPuan,
    this.basvuruTarihi,
  });

factory JuriBasvuru.fromJson(Map<String, dynamic> json) {
  return JuriBasvuru(
    basvuruID: json['BasvuruID'],
    ilanID: json['IlanID'],
    adayAd: json['AdayAd'] ?? '',
    adaySoyad: json['AdaySoyad'] ?? '',
    ilanBaslik: json['IlanBaslik'] ?? '',
    durum: json['Sonuc'] ?? '',
    toplamPuan: double.tryParse(json['ToplamPuan'].toString()) ?? 0.0,
    basvuruTarihi: json['BasvuruTarihi'] != null ? DateTime.parse(json['BasvuruTarihi']) : null,
    juriUyesiID: json['JuriUyesiID'],
  );
}
}

class JuriDegerlendirmeModel {
  final int? basvuruID;
  final int? ilanID;
  final int? juriUyesiID;
  final String tcKimlikNo;
  final bool sonuc;
  final String aciklama;
  final String degerlendirmeRaporuYolu;

  JuriDegerlendirmeModel({
    required this.basvuruID,
    required this.ilanID,
    required this.juriUyesiID,
    required this.tcKimlikNo,
    required this.sonuc,
    required this.aciklama,
    required this.degerlendirmeRaporuYolu,
  });

  Map<String, dynamic> toJson() {
    return {
      'BasvuruID': basvuruID,
      'IlanID': ilanID,
      'JuriUyesiID': juriUyesiID,
      'TcKimlikNo': tcKimlikNo,
      'Sonuc': sonuc ? 1 : 0,
      'Aciklama': aciklama,
      'DegerlendirmeRaporuYolu': degerlendirmeRaporuYolu,
    };
  }
}


