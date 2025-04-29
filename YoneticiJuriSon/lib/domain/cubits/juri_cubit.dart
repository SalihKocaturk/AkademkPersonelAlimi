import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/juri_model.dart';
import '../../repositories/jury_repository.dart';
import '../states/juri_state.dart';

class JuryCubit extends Cubit<JuryState> {
    JuryCubit() : super(JuryInitial());

  final JuryRepository _repo = JuryRepository();
  final JuriDegerlendirmeRepository _degerlendirmeRepo = JuriDegerlendirmeRepository();

  
void juryBasvurulariGetir() async {
  emit(JuryLoading());
  try {
    final basvurular = await _repo.juriBasvurulariniGetir();

    if (basvurular.isEmpty) {
      print('🟥 Gelen liste boş.');
    } else {
      for (var basvuru in basvurular) {
        print('Başvuru Başlığı: ${basvuru.ilanBaslik}');
      }
    }

    emit(JuryLoaded(basvurular, []));
  } catch (e) {
    print('🟥 Hata yakalandı: $e');
    emit(JuryError('Başvurular yüklenemedi: $e'));
  }
}
void degerlendirmeGonder(JuriDegerlendirmeModel degerlendirme) async {
  try {
    await _degerlendirmeRepo.degerlendirmeYolla(degerlendirme);
    juryBasvurulariGetir();
    } catch (e) {
    emit(JuriDegerlendirmeHata('Değerlendirme kaydedilemedi: $e'));
  }
}
}
