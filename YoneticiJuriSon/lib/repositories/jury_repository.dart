import 'package:dio/dio.dart';
import '../models/juri_model.dart';

class JuryRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<List<JuriBasvuru>> juriBasvurulariniGetir() async {
    final response = await _dio.get('/juri-basvurular');
    final List<dynamic> data = response.data;

    return data.map((json) => JuriBasvuru.fromJson(json)).toList();
  }
}

class JuriDegerlendirmeRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<void> degerlendirmeYolla(JuriDegerlendirmeModel model) async {
    await _dio.post('/juri-degerlendirme', data: model.toJson());
  }
}



