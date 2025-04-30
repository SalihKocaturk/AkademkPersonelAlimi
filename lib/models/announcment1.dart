import 'dart:convert';
import 'package:equatable/equatable.dart';

class Announcement1 extends Equatable {
  final int id;
  final String title;
  final String description;
  final int kadroTipiId;
  final int temelAlanId;
  final DateTime startDate; // <-- String değil DateTime
  final DateTime endDate; // <-- String değil DateTime
  final List<String> requiredDocuments;
  final String? applicationConditions;
  final int olusturanAdminId;

  const Announcement1({
    required this.id,
    required this.title,
    required this.description,
    required this.kadroTipiId,
    required this.temelAlanId,
    required this.startDate,
    required this.endDate,
    required this.requiredDocuments,
    required this.applicationConditions,
    required this.olusturanAdminId,
  });

  factory Announcement1.fromJson(Map<String, dynamic> json) {
    final rawDocuments = json['GerekliBelgeler'];
    List<String> parsedDocuments;

    if (rawDocuments != null) {
      if (rawDocuments is String) {
        if (rawDocuments.trim().startsWith('[')) {
          parsedDocuments = List<String>.from(jsonDecode(rawDocuments));
        } else {
          parsedDocuments =
              rawDocuments.split(',').map((e) => e.trim()).toList();
        }
      } else {
        parsedDocuments = List<String>.from(rawDocuments);
      }
    } else {
      parsedDocuments = [];
    }

    return Announcement1(
      id: json['IlanID'],
      title: json['Baslik'] ?? '',
      description: json['Aciklama'] ?? '',
      kadroTipiId: json['KadroTipiID'] ?? 0,
      temelAlanId: json['TemelAlanID'] ?? 0,
      startDate: DateTime.parse(json['BaslangicTarihi']),
      endDate: DateTime.parse(json['BitisTarihi']),
      requiredDocuments: parsedDocuments,
      applicationConditions: json['BasvuruKosullari'],
      olusturanAdminId: json['OlusturanAdminID'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'Baslik': title,
    'Aciklama': description,
    'KadroTipiID': kadroTipiId,
    'TemelAlanID': temelAlanId,
    'BaslangicTarihi':
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    'BitisTarihi':
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",

    'GerekliBelgeler': jsonEncode(requiredDocuments),
    'OlusturanAdminID': olusturanAdminId,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    kadroTipiId,
    temelAlanId,
    startDate,
    endDate,
    requiredDocuments,
    applicationConditions,
    olusturanAdminId,
  ];
}
