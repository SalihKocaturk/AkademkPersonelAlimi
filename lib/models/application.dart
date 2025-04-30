import 'package:equatable/equatable.dart';

class Application extends Equatable {
  final int basvuruId;
  final String adayTC;
  final int ilanId;
  final DateTime basvuruTarihi;
  final String basvuruDurumu;

  const Application({
    required this.basvuruId,
    required this.adayTC,
    required this.ilanId,
    required this.basvuruTarihi,
    required this.basvuruDurumu,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      basvuruId: json['BasvuruID'],
      adayTC: json['AdayTC'],
      ilanId: json['IlanID'],
      basvuruTarihi: DateTime.parse(json['BasvuruTarihi']),
      basvuruDurumu: json['BasvuruDurumu'] ?? "Bekliyor",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BasvuruID': basvuruId,
      'AdayTC': adayTC,
      'IlanID': ilanId,
      'BasvuruTarihi': basvuruTarihi.toIso8601String(),
      'BasvuruDurumu': basvuruDurumu,
    };
  }

  @override
  List<Object?> get props => [
    basvuruId,
    adayTC,
    ilanId,
    basvuruTarihi,
    basvuruDurumu,
  ];
}
