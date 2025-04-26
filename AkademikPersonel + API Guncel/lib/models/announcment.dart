import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  final String id;
  final String title;
  final String position;
  final String startDate;
  final String endDate;
  final List<String> requiredDocuments;
  final String description;
  final List<String> criteriaTabs;

  const Announcement({
    required this.id,
    required this.title,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.requiredDocuments,
    required this.description,
    required this.criteriaTabs,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'],
    title: json['title'],
    position: json['position'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    requiredDocuments: List<String>.from(json['requiredDocuments']),
    description: json['description'],
    criteriaTabs: List<String>.from(json['criteriaTabs']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'position': position,
    'startDate': startDate,
    'endDate': endDate,
    'requiredDocuments': requiredDocuments,
    'description': description,
    'criteriaTabs': criteriaTabs,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    position,
    startDate,
    endDate,
    requiredDocuments,
    description,
    criteriaTabs,
  ];
  Announcement copyWith({
    String? id,
    String? title,
    String? position,
    String? startDate,
    String? endDate,
    List<String>? requiredDocuments,
    String? description,
    List<String>? criteriaTabs,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      description: description ?? this.description,
      criteriaTabs: criteriaTabs ?? this.criteriaTabs,
    );
  }
}
