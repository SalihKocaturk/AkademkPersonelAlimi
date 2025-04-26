import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/yonetici_model.dart';
import '../../repositories/manager_repository.dart';
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
  final KriterRepository _repo = KriterRepository();

void kriterleriSunucudanGetir() async {
  emit(YoneticiYukleniyor());
  try {
    final kriterList = await _repo.kriterleriGetir();
    emit(YoneticiYuklendi(kriterList));
  } catch (e) {
    emit(YoneticiHata('Veriler alınamadı: $e'));
  }
}

void kriterSunucuyaEkle(KadroKriter yeniKriter) async {
  emit(YoneticiYukleniyor());
  try {
    await _repo.kriterEkle(yeniKriter);
    kriterleriSunucudanGetir();
  } catch (e) {
    emit(YoneticiHata('Kriter eklenemedi: $e'));
  }
}

void kriterSunucudanSil(int kriterID) async {
  emit(YoneticiYukleniyor());
  try {
    await _repo.kriterSil(kriterID);
    kriterleriSunucudanGetir();
  } catch (e) {
    emit(YoneticiHata('Kriter silinemedi: $e'));
  }
}
void kriterSunucudaGuncelle(KadroKriter kriter, int kriterID) async {
  emit(YoneticiYukleniyor());
  try {
    await _repo.kriterGuncelle(kriter, kriterID);
    kriterleriSunucudanGetir();
  } catch (e) {
    emit(YoneticiHata('Kriter güncellenemedi: $e'));
  }
}

final IlanRepository _ilanRepo = IlanRepository();

void basvurulariYukle() async {
  emit(YoneticiYukleniyor());
  try {
    final basvurular = await _ilanRepo.basvurulariGetir();
    emit(YoneticiBasvurularYuklendi(basvurular));
  } catch (e) {
    emit(YoneticiHata('Başvurular yüklenemedi: $e'));
  }
}
void basvuruDurumGuncelle(int basvuruID, String yeniDurum) async {
  try {
    await _ilanRepo.basvuruDurumGuncelle(basvuruID, yeniDurum);
    basvurulariYukle();
  } catch (e) {
    emit(YoneticiHata('Durum güncelleme hatası: $e'));
  }
}

}

