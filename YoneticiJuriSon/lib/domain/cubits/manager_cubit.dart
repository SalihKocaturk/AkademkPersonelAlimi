import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/yonetici_model.dart';
import '../../repositories/manager_repository.dart';
part '../states/manager_state.dart.dart';


class ManagerCubit extends Cubit<YoneticiState> {
  ManagerCubit() : super(YoneticiInitial());

  final Map<String, List<JuriUyesi>> _ilanJuriListesi = {};

  List<JuriUyesi> getJuriListesi(String ilanId) {
    return List.unmodifiable(_ilanJuriListesi[ilanId] ?? []);
  }


  final KriterRepository _repo = KriterRepository();


void kriterSunucuyaEkle(KadroKriter yeniKriter) async {
  emit(YoneticiKriterlerYukleniyor());
  try {
    await _repo.kriterEkle(yeniKriter);
    basvuruKriterYukle();
  } catch (e) {
    emit(YoneticiHata('Kriter eklenemedi: $e'));
  }
}

void kriterSunucudanSil(int kriterID) async {
  emit(YoneticiKriterlerYukleniyor());
  try {
    await _repo.kriterSil(kriterID);
    basvuruKriterYukle();
  } catch (e) {
    emit(YoneticiHata('Kriter silinemedi: $e'));
  }
}
void kriterSunucudaGuncelle(KadroKriter kriter, int kriterID) async {
  emit(YoneticiKriterlerYukleniyor());
  try {
    await _repo.kriterGuncelle(kriter, kriterID);
    basvuruKriterYukle();
  } catch (e) {
    emit(YoneticiHata('Kriter güncellenemedi: $e'));
  }
}

final IlanRepository _ilanRepo = IlanRepository();
final JuriIlanRepository _juriIlanRepo = JuriIlanRepository();
final JuriKullaniciRepos _juriKullaniciRepo = JuriKullaniciRepos();
final JuriAtamaRepository _juriAtaRepo = JuriAtamaRepository();

void basvuruKriterYukle()async{
  emit(YoneticiBasvurularYukleniyor());
  try {
    final basvurular = await _ilanRepo.basvurulariGetir();
    final kriterList = await _repo.kriterleriGetir();
    final juriIlanList = await _juriIlanRepo.juriIlanGetir();
    final juriKullaniciList = await _juriKullaniciRepo.juriKullanicilariGetir();
    

    emit(YoneticiBilgileriYuklendi(kriterList, basvurular, juriIlanList, juriKullaniciList));
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
void basvuruDurumGuncelle(int basvuruID, String yeniDurum) async {
  try {
    await _ilanRepo.basvuruDurumGuncelle(basvuruID, yeniDurum);
    basvuruKriterYukle();
  } catch (e) {
    emit(YoneticiHata('Durum güncelleme hatası: $e'));
  }
}
void juriAta(JuriAtamaModel atamaModel) async {
  emit(YoneticiJuriAtamaYukleniyor());
  try {
    await _juriAtaRepo.juriAta(atamaModel);
    basvuruKriterYukle();
  } catch (e) {
    emit(YoneticiHata('Jüri Atama Hatası: $e'));
  }
}
}
