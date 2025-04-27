import 'package:dio/dio.dart';

class JuriLoginRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<Map<String, dynamic>> juriGirisYap(String tcKimlikNo, String sifre) async {
    final response = await _dio.post('/jurigiris', data: {
      'TCKimlikNo': tcKimlikNo,
      'Sifre': sifre,
    });

    return response.data;
  }
}
