part of '../cubits/juri_cubit.dart';

abstract class JuriState {}

class JuriInitial extends JuriState {}

class JuriDegerlendirmeGuncellendi extends JuriState {
  final String not;
  final bool? kararOlumlu;
  final String? dosyaYolu;

  JuriDegerlendirmeGuncellendi({
    required this.not,
    required this.kararOlumlu,
    required this.dosyaYolu,
  });
}

class JuriDegerlendirmeEksik extends JuriState {
  final String mesaj;

  JuriDegerlendirmeEksik(this.mesaj);
}

class JuriDegerlendirmeTamamlandi extends JuriState {}
