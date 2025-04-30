import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/announcment1.dart';
part '../states/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial()) {
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    emit(AdminLoading());
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/announcements'),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List decoded = jsonDecode(response.body);
        print(decoded.length);

        final list = decoded.map((e) => Announcement1.fromJson(e)).toList();
        print(list.length);
        emit(AdminLoaded(list));
      } else {
        emit(AdminLoaded([]));
      }
    } catch (e) {
      emit(AdminLoaded([]));
    }
  }

  Future<void> addAnnouncement(Announcement1 a) async {
    try {
      final data = a.toJson();
      print("Gönderilen veri: $data");
      await http.post(
        Uri.parse('http://localhost:3000/announcements'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print(jsonEncode(data));
      loadAnnouncements();
    } catch (e) {
      print("Hata addAnnouncement içinde: $e"); 
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      await http.delete(Uri.parse('http://localhost:3000/announcements/$id'));
      loadAnnouncements();
    } catch (_) {}
  }

  Future<void> updateAnnouncement(Announcement1 a) async {
    try {
      print(a.title);
      final data = a.toJson();
      print(data.isEmpty);
      print(data);
      await http.put(
        Uri.parse('http://localhost:3000/announcements/${a.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      loadAnnouncements();
    } catch (e) {
      print("Güncelleme hatası: $e");
    }
  }
}
