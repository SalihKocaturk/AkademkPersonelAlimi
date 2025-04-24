import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/yonetici_model.dart';
part '../states/manager_state.dart.dart';

class ManagerCubit extends Cubit<YoneticiState> {
  ManagerCubit() : super(YoneticiInitial());

  final List<KadroKriter> _kriterListesi = [];

  void kriterleriGetir() {
    emit(YoneticiYukleniyor());
    emit(YoneticiYuklendi(List.from(_kriterListesi)));
  }

  void kriterEkle(KadroKriter yeniKriter) {
    _kriterListesi.add(yeniKriter);
    emit(YoneticiYuklendi(List.from(_kriterListesi)));
  }

  void kriterGuncelle(int index, KadroKriter guncellenmisKriter) {
    if (index >= 0 && index < _kriterListesi.length) {
      _kriterListesi[index] = guncellenmisKriter;
      emit(YoneticiYuklendi(List.from(_kriterListesi)));
    }
  }

  void kriterSil(int index) {
    if (index >= 0 && index < _kriterListesi.length) {
      _kriterListesi.removeAt(index);
      emit(YoneticiYuklendi(List.from(_kriterListesi)));
    }
  }

  final Map<String, List<JuriUyesi>> _ilanJuriListesi = {};

  void juriEkle(String ilanId, JuriUyesi uye) {
    final juriListesi = _ilanJuriListesi[ilanId] ?? [];
    if (juriListesi.length < 5) {
      juriListesi.add(uye);
      _ilanJuriListesi[ilanId] = juriListesi;
      emit(YoneticiYuklendi(List.from(_kriterListesi)));
    }
  }

  List<JuriUyesi> getJuriListesi(String ilanId) {
    return List.unmodifiable(_ilanJuriListesi[ilanId] ?? []);
  }

  void juriSil(String ilanId, String tcKimlik) {
    final liste = _ilanJuriListesi[ilanId];
    if (liste != null) {
      liste.removeWhere((j) => j.tcKimlik == tcKimlik);
      emit(YoneticiYuklendi(List.from(_kriterListesi)));
    }
  }

  void kriterleriTemizle() {
    _kriterListesi.clear();
    emit(YoneticiYuklendi([]));
  }
}
