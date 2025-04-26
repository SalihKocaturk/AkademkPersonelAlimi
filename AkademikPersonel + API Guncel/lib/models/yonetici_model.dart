class KategoriKriter {
  final String kod;
  final int gerekliAdet;
  final double? minPuan;
  final double? maxPuan;

  KategoriKriter({
    required this.kod,
    required this.gerekliAdet,
    this.minPuan,
    this.maxPuan,
  });

factory KategoriKriter.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return KategoriKriter(
      kod: json['kod'] ?? '',
      gerekliAdet: int.tryParse(json['gerekliAdet'].toString()) ?? 0,
      minPuan: toDouble(json['minPuan']),
      maxPuan: toDouble(json['maxPuan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kod': kod,
      'gerekliAdet': gerekliAdet,
      'minPuan': minPuan,
      'maxPuan': maxPuan,
    };
  }
}

class KadroKriter {
  final int kriterID;
  final String kadroTuru;
  final String temelAlan;
  final List<KategoriKriter> kategoriKriterleri;
  final double minToplamPuan;

  KadroKriter({
    required this.kriterID,
    required this.kadroTuru,
    required this.temelAlan,
    required this.kategoriKriterleri,
    required this.minToplamPuan,
  });

  factory KadroKriter.fromJson(Map<String, dynamic> json) {
    var list = json['kategoriKriterleri'] as List<dynamic>? ?? [];
    List<KategoriKriter> kategoriListesi = list.map((e) => KategoriKriter.fromJson(e)).toList();

    return KadroKriter(
      kriterID: json['KriterID'] ?? 0,
      kadroTuru: json['kadroTuru'] ?? '',
      temelAlan: json['temelAlan'] ?? '',
      kategoriKriterleri: kategoriListesi,
      minToplamPuan: (json['minToplamPuan'] != null) ? (json['minToplamPuan'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kadroTuru': kadroTuru,
      'temelAlan': temelAlan,
      'kategoriKriterleri': kategoriKriterleri.map((e) => e.toJson()).toList(),
      'minToplamPuan': minToplamPuan,
    };
  }
}

class JuriUyesi {
  final String tcKimlik;
  final String adSoyad;
  final String unvan;
  final String kurum;

  JuriUyesi({
    required this.tcKimlik,
    required this.adSoyad,
    required this.unvan,
    required this.kurum,
  });

  factory JuriUyesi.fromJson(Map<String, dynamic> json) {
    return JuriUyesi(
      tcKimlik: json['tcKimlik'] ?? '',
      adSoyad: json['adSoyad'] ?? '',
      unvan: json['unvan'] ?? '',
      kurum: json['kurum'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tcKimlik': tcKimlik,
      'adSoyad': adSoyad,
      'unvan': unvan,
      'kurum': kurum,
    };
  }
}

//------------BAŞVURULARI İNCELE-----------------

class Basvuru {
  final int basvuruID;
  final String adayAdSoyad;
  final String ilanBaslik;
  final int ilanID;
  final String basvuruTarihi;
  final String baslangicTarihi;
  final String bitisTarihi;
  final String durum;
  final double toplamPuan;
  final String sonGuncelleme;

  Basvuru({
    required this.basvuruID,
    required this.adayAdSoyad,
    required this.ilanBaslik,
    required this.ilanID,
    required this.basvuruTarihi,
    required this.baslangicTarihi,
    required this.bitisTarihi,
    required this.durum,
    required this.toplamPuan,
    required this.sonGuncelleme,
  });

factory Basvuru.fromJson(Map<String, dynamic> json) {
  double toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  return Basvuru(
    basvuruID: json['BasvuruID'],
    adayAdSoyad: '${json['AdayAd']} ${json['AdaySoyad']}',
    ilanBaslik: json['IlanBaslik'],
    ilanID: json['IlanID'],
    basvuruTarihi: json['BasvuruTarihi'],
    baslangicTarihi: json['BaslangicTarihi'],
    bitisTarihi: json['BitisTarihi'],
    durum: json['Durum'],
    toplamPuan: toDouble(json['ToplamPuan']), 
    sonGuncelleme: json['SonGuncelleme'],
  );
}

}

