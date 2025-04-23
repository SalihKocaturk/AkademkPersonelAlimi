// admin_cubit.dart
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proje1/models/announcment.dart';
import 'package:shared_preferences/shared_preferences.dart';
part '../states/admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial()) {
    loadAnnouncements();
  }
  void updateAnnouncement(Announcement updated) {
    if (state is AdminLoaded) {
      final current = (state as AdminLoaded).announcements;
      final index = current.indexWhere((ann) => ann.id == updated.id);
      if (index != -1) {
        final updatedList = List<Announcement>.from(current);
        updatedList[index] = updated;
        emit(AdminLoaded(updatedList));
      }
    }
  }

  Future<void> loadAnnouncements() async {
    emit(AdminLoading());
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('announcements');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      final list = decoded.map((e) => Announcement.fromJson(e)).toList();
      emit(AdminLoaded(list));
    } else {
      emit(AdminLoaded([]));
    }
  }

  Future<void> addAnnouncement(Announcement a) async {
    final currentState = state;
    if (currentState is AdminLoaded) {
      final updated = [...currentState.announcements, a];
      await _save(updated);
      emit(AdminLoaded(updated));
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final currentState = state;
    if (currentState is AdminLoaded) {
      final updated =
          currentState.announcements.where((e) => e.id != id).toList();
      await _save(updated);
      emit(AdminLoaded(updated));
    }
  }

  Future<void> _save(List<Announcement> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'announcements',
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }
}
