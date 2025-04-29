import 'package:flutter_bloc/flutter_bloc.dart';
part '../states/juri_state.dart';

class JuriCubit extends Cubit<JuriState> {
  JuriCubit() : super(JuriInitial());

  String _degerlendirmeNotu = '';
  bool? _kararOlumlu;
  String? _yuklenenDosyaYolu;

  void notGuncelle(String not) {
    _degerlendirmeNotu = not;
    emit(
      JuriDegerlendirmeGuncellendi(
        not: _degerlendirmeNotu,
        kararOlumlu: _kararOlumlu,
        dosyaYolu: _yuklenenDosyaYolu,
      ),
    );
  }

  void kararGuncelle(bool olumluMu) {
    _kararOlumlu = olumluMu;
    emit(
      JuriDegerlendirmeGuncellendi(
        not: _degerlendirmeNotu,
        kararOlumlu: _kararOlumlu,
        dosyaYolu: _yuklenenDosyaYolu,
      ),
    );
  }

  void dosyaYukle(String yol) {
    _yuklenenDosyaYolu = yol;
    emit(
      JuriDegerlendirmeGuncellendi(
        not: _degerlendirmeNotu,
        kararOlumlu: _kararOlumlu,
        dosyaYolu: _yuklenenDosyaYolu,
      ),
    );
  }

  void tamamlaDegerlendirme() {
    if (_degerlendirmeNotu.isNotEmpty &&
        _kararOlumlu != null &&
        _yuklenenDosyaYolu != null) {
      emit(JuriDegerlendirmeTamamlandi());
    } else {
      emit(JuriDegerlendirmeEksik('Lütfen tüm alanları doldurun.'));
    }
  }
}
