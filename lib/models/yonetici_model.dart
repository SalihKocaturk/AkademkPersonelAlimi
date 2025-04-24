class KategoriKriter {
  final String kod;
  final int gerekliAdet;
  final bool zorunluMu;
  final double? minPuan;
  final double? maxPuan;

  KategoriKriter({
    required this.kod,
    required this.gerekliAdet,
    required this.zorunluMu,
    this.minPuan,
    this.maxPuan,
  });


  KategoriKriter copyWith({
    String? kod,
    int? gerekliAdet,
    bool? zorunluMu,
    double? minPuan,
    double? maxPuan,
  }) {
    return KategoriKriter(
      kod: kod ?? this.kod,
      gerekliAdet: gerekliAdet ?? this.gerekliAdet,
      zorunluMu: zorunluMu ?? this.zorunluMu,
      minPuan: minPuan ?? this.minPuan,
      maxPuan: maxPuan ?? this.maxPuan,
    );
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
}


class KadroKriter {
  final String kadroTuru;
  final List<KategoriKriter> kategoriKriterleri;
  final double minToplamPuan;

  KadroKriter({
    required this.kadroTuru,
    required this.kategoriKriterleri,
    required this.minToplamPuan,
  });

  KadroKriter copyWith({
    String? kadroTuru,
    List<KategoriKriter>? kategoriKriterleri,
    double? minToplamPuan,
  }) {
    return KadroKriter(
      kadroTuru: kadroTuru ?? this.kadroTuru,
      kategoriKriterleri: kategoriKriterleri ?? this.kategoriKriterleri,
      minToplamPuan: minToplamPuan ?? this.minToplamPuan,
    );
  }
}
