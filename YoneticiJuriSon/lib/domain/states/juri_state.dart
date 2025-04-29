import '../../models/juri_model.dart';

abstract class JuryState {}

class JuryInitial extends JuryState {}

class JuryLoading extends JuryState {}

class JuryLoaded extends JuryState {
  final List<JuriBasvuru> basvurular;
  final List<JuriDegerlendirmeModel> basvuruDegerlendirmeListesi;

  JuryLoaded(this.basvurular, this.basvuruDegerlendirmeListesi);
}
class JuriDegerlendirmeBasarili extends JuryState{}

class JuriDegerlendirmeHata extends JuryState {
  final String mesaj;
  JuriDegerlendirmeHata(this.mesaj);
}
class JuryError extends JuryState {
  final String message;
  JuryError(this.message);
}

