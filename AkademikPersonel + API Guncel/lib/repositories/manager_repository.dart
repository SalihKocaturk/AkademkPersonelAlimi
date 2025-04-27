import 'package:dio/dio.dart';
import '../models/yonetici_model.dart';

class KriterRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<List<KadroKriter>> kriterleriGetir() async {
    final response = await _dio.get('/kadro-kriterleri');
    final List<dynamic> data = response.data;

    return data.map((json) {
      final kategori = KategoriKriter(
        kod: json['FaaliyetKodu'] as String,
        gerekliAdet: (json['MinSayi'] is num
            ? json['MinSayi'] as int
            : int.tryParse(json['MinSayi'].toString()) ?? 0),
        minPuan: (json['MinPuan'] is num
            ? (json['MinPuan'] as num).toDouble()
            : double.tryParse(json['MinPuan'].toString()) ?? 0.0),
        maxPuan: (json['PuanDegeri'] is num
            ? (json['PuanDegeri'] as num).toDouble()
            : double.tryParse(json['PuanDegeri'].toString()) ?? 0.0),
      );

      return KadroKriter(
        kriterID: json['KriterID'] ?? 0,
        kadroTuru: _idToKadroTuru(json['KadroTipiID']),
        temelAlan: _idToTemelAlan(json['TemelAlanID']),
        kategoriKriterleri: [kategori],
        minToplamPuan: (json['MinPuan'] is num
            ? (json['MinPuan'] as num).toDouble()
            : double.tryParse(json['MinPuan'].toString()) ?? 0.0),
      );
    }).toList();
  }
Future<void> kriterGuncelle(KadroKriter kriter, int kriterID) async {
  await _dio.put('/kadro-kriterleri/$kriterID', data: {
    "KadroTipiID": _kadroTuruToID(kriter.kadroTuru),
    "TemelAlanID": _temelAlanToID(kriter.temelAlan),
    "FaaliyetKodu": kriter.kategoriKriterleri.first.kod,
    "MinPuan": kriter.kategoriKriterleri.first.minPuan,
    "MinSayi": kriter.kategoriKriterleri.first.gerekliAdet,
    "PuanDegeri": kriter.kategoriKriterleri.first.maxPuan,
  });
}


String _kadroTuruToID(String kadroTuru) {
  switch (kadroTuru) {
    case 'Doçent':
      return '2';
    case 'Profesör':
      return '3';
    default:
      return '1';
  }
}

String _temelAlanToID(String temelAlan) {
  switch (temelAlan) {
    case 'Fen Bilimleri ve Matematik':
      return '2';
    case 'Sağlık Bilimleri':
      return '3';
    case 'Güzel Sanatlar':
      return '4';
    default:
      return '1';
  }
}

  String _idToKadroTuru(dynamic id) {
    final i = int.tryParse(id.toString()) ?? 1;
    switch (i) {
      case 2:
        return 'Doçent';
      case 3:
        return 'Profesör';
      default:
        return 'Dr. Öğr. Üyesi';
    }
  }

  String _idToTemelAlan(dynamic id) {
    final i = int.tryParse(id.toString()) ?? 1;
    switch (i) {
      case 2:
        return 'Fen Bilimleri ve Matematik';
      case 3:
        return 'Sağlık Bilimleri';
      case 4:
        return 'Güzel Sanatlar';
      default:
        return 'Mühendislik';
    }
  }


  Future<void> kriterEkle(KadroKriter kriter) async {
    await _dio.post('/kadro-kriterleri', data: {
      "KadroTipiID": int.parse(kadroTuruToID(kriter.kadroTuru)),
      "TemelAlanID": int.parse(temelAlanToID(kriter.temelAlan)),
      "FaaliyetKodu": kriter.kategoriKriterleri.first.kod,
      "MinPuan": kriter.minToplamPuan,
      "MinSayi": kriter.kategoriKriterleri.first.gerekliAdet,
      "PuanDegeri": kriter.kategoriKriterleri.first.maxPuan ?? 0,
    });
  }

Future<void> kriterSil(int kriterID) async {
  await _dio.delete('/kadro-kriterleri/$kriterID');
}

    String temelAlanToID(String temelAlan){
  switch(temelAlan){
    case "Mühendislik":
      return '1';
    case "Fen Bilimleri ve Matematik":
      return '2';
    case "Sağlık Bilimleri":
      return '3';
    case "Güzel Sanatlar":
      return '4';
    default:
      return '1';
  }
    }
  String kadroTuruToID(String kadroTuru) {
    switch (kadroTuru) {
      case "Doçent":
        return '2';
      case "Profesör":
        return '3';
      default:
        return '1';
    }
  }
}

//İLANLARI GÖRÜNTÜLE-----------------------------
class IlanRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<List<Basvuru>> basvurulariGetir() async {
    final response = await _dio.get('/basvurular');
    final List<dynamic> data = response.data;
    return data.map((e) => Basvuru.fromJson(e)).toList();
  }
  Future<void> basvuruDurumGuncelle(int basvuruID, String yeniDurum) async {
  await _dio.put('/basvurular/$basvuruID', data: {
    'yeniDurum': yeniDurum,
  });
}
}
class JuriIlanRepository{
    final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

    Future <List<JuriIlan>> juriIlanGetir() async{
          final response = await _dio.get('/ilanlar');
          final List<dynamic> data = response.data;
          return data.map((e) => JuriIlan.fromJson(e)).toList();
    }
}

class JuriKullaniciRepos{
    final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
    Future <List<JuriKullanicilar>> juriKullanicilariGetir() async{
          final response = await _dio.get('/kullanicijuri');
          final List<dynamic> data = response.data;
          return data.map((e) => JuriKullanicilar.fromJson(e)).toList();
    }
}
class JuriAtamaRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<void> juriAta(JuriAtamaModel atamaModel) async {
    await _dio.post('/juri-atama', data: atamaModel.toJson());
  }
}



