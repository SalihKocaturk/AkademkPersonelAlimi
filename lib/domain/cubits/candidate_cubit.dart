import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../models/announcment1.dart';
import '../../models/application.dart';

part '../states/candidate_state.dart';

class CandidateCubit extends Cubit<CandidateState> {
  CandidateCubit() : super(CandidateInitial()) {
    fetchAnnouncementsAndApplications();
  }

  Future<void> fetchAnnouncementsAndApplications() async {
    emit(CandidateLoading());
    try {
      final announcementsResponse = await http.get(
        Uri.parse('http://localhost:3000/announcements'),
      );
      final applicationsResponse = await http.get(
        Uri.parse('http://localhost:3000/applications'),
      );

      List<Announcement1> announcements = [];
      List<Application> applications = [];
      print("announcmentResponse ${announcementsResponse.statusCode}");
      if (announcementsResponse.statusCode == 200) {
        final List annDecoded = jsonDecode(announcementsResponse.body);
        print(annDecoded.length);
        announcements =
            annDecoded.map((e) => Announcement1.fromJson(e)).toList();
        print("ann length:${announcements.length}");
      }
      print("ann length:${announcements.length}");

      // if (applicationsResponse.statusCode == 200) {
      //   final appDecoded = jsonDecode(applicationsResponse.body);
      //   applications =
      //       (appDecoded as List).map((e) => Application.fromJson(e)).toList();
      // }
      print("ann length:${announcements.length}");
      print("app length:${applications.length}");

      emit(
        CandidateLoaded(
          announcements: announcements,
          applications: applications,
        ),
      );
    } catch (e) {
      emit(CandidateLoaded(announcements: [], applications: []));
    }
  }

  Future<void> applyToAnnouncement(String announcementId) async {
    try {
      await http.post(
        Uri.parse('http://localhost:3000/applications'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'announcementId': announcementId,
          'appliedAt': DateTime.now().toIso8601String(),
        }),
      );
      fetchAnnouncementsAndApplications();
    } catch (e) {}
  }

  Future<Map<String, String>?> fetchCandidateInfo(String tc) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/users/$tc'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'ad': data['Ad'], 'soyad': data['Soyad']};
      }
    } catch (e) {
      print("Kullanıcı bilgisi çekilemedi: $e");
    }
    return null;
  }
}
