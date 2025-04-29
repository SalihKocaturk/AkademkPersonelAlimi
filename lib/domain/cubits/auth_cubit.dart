import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part '../states/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({required String tc, required String sifre}) async {
    emit(AuthLoading());

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tc': tc, 'sifre': sifre}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(
          AuthLoggedIn(
            rol: data['rol'],
            ad: data['ad'],
            soyad: data['soyad'],
            tc: data['tc'],
          ),
        );
      } else {
        emit(AuthFailure('Geçersiz kimlik numarası veya şifre'));
      }
    } catch (e) {
      emit(AuthFailure('Giriş sırasında hata oluştu'));
    }
  }

  Future<void> registerWithSOAP({
    required String tc,
    required String ad,
    required String soyad,
    required int dogumYili,
    required String sifre,
    required String eposta,
    required int rolId,
  }) async {
    emit(AuthLoading());

    final soapBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <TCKimlikNoDogrula xmlns="http://tckimlik.nvi.gov.tr/WS">
      <TCKimlikNo>$tc</TCKimlikNo>
      <Ad>$ad</Ad>
      <Soyad>$soyad</Soyad>
      <DogumYili>$dogumYili</DogumYili>
    </TCKimlikNoDogrula>
  </soap:Body>
</soap:Envelope>
''';

    bool soapSuccessful = false;

    try {
      final response = await http.post(
        Uri.parse('https://tckimlik.nvi.gov.tr/Service/KPSPublic.asmx'),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tckimlik.nvi.gov.tr/WS/TCKimlikNoDogrula',
        },
        body: soapBody,
      );

      if (response.statusCode == 200 &&
          response.body.contains(
            '<TCKimlikNoDogrulaResult>true</TCKimlikNoDogrulaResult>',
          )) {
        soapSuccessful = true;
      }
    } catch (e) {
      // SOAP isteği başarısız olsa bile hata fırlatma
      print('SOAP Hatası: $e');
    }

    // Her durumda veritabanına kayıt yapılacak
    try {
      final dbResponse = await http.post(
        Uri.parse('http://localhost:3000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tc': tc,
          'ad': ad,
          'soyad': soyad,
          'dogumYili': dogumYili,
          'sifre': sifre,
          'eposta': eposta,
          'rolId': rolId,
          'soapDogrulama': soapSuccessful,
        }),
      );

      if (dbResponse.statusCode == 200) {
        emit(
          AuthSuccess(
            soapSuccessful
                ? 'Kimlik doğrulandı ve kayıt başarılı!'
                : 'SOAP doğrulaması yapılamadı ama kayıt başarılı.',
          ),
        );
      } else {
        emit(AuthFailure('Veritabanına kayıt başarısız.'));
      }
    } catch (e) {
      emit(AuthFailure('Veritabanı hatası: $e'));
    }
  }
}
