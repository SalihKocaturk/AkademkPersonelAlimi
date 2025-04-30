/// candidate_home.dart (Güncellenmiş Final Sürüm)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/cubits/auth_cubit.dart';
import '../../domain/cubits/candidate_cubit.dart';
import '../../locator.dart';
import '../../models/announcment1.dart';
import '../../models/application.dart';
import '../widgets/logout_button.dart';

class CandidateHome extends StatelessWidget {
  const CandidateHome({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<CandidateCubit>().fetchAnnouncementsAndApplications();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aday Paneli'),
          actions: const [LogoutButton()],
          bottom: const TabBar(
            tabs: [Tab(text: "📢 Duyurular"), Tab(text: "📄 Başvurularım")],
          ),
        ),
        body: BlocBuilder<CandidateCubit, CandidateState>(
          bloc: getIt<CandidateCubit>(),
          builder: (context, state) {
            if (state is CandidateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CandidateLoaded) {
              return TabBarView(
                children: [
                  _buildAnnouncementsTab(
                    context,
                    state.announcements,
                    state.applications,
                  ),
                  _buildApplicationsTab(
                    context,
                    state.announcements,
                    state.applications,
                  ),
                ],
              );
            }
            return const Center(child: Text("Bir hata oluştu."));
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementsTab(
    BuildContext context,
    List<Announcement1> announcements,
    List<Application> applications,
  ) {
    if (announcements.isEmpty) {
      return const Center(
        child: Text(
          "Herhangi bir duyuru bulunmamaktadır.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    final authState = getIt<AuthCubit>().state;
    String adSoyad = '';
    if (authState is AuthLoggedIn) {
      adSoyad = '${authState.ad} ${authState.soyad}';
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final ann = announcements[index];
        final isApplied = applications.any((app) => app.ilanId == ann.id);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ann.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _infoBox("Kadro Tipi ID", ann.kadroTipiId.toString()),
                    _infoBox("Temel Alan ID", ann.temelAlanId.toString()),
                    _infoBox(
                      "Başlangıç Tarihi",
                      ann.startDate.toLocal().toString().split(' ')[0],
                    ),
                    _infoBox(
                      "Bitiş Tarihi",
                      ann.endDate.toLocal().toString().split(' ')[0],
                    ),

                    _infoBox(
                      "Gerekli Belgeler",
                      ann.requiredDocuments.join(", "),
                    ),
                    _infoBox("Açıklama", ann.description),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.pushNamed(
                        'candidateApplication',
                        extra: {'adSoyad': adSoyad, 'ilanBaslik': ann.title},
                      );

                      // getIt<CandidateCubit>().applyToAnnouncement(
                      //   ann.id.toString(),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Başvuru yapıldı!"),
                      //   ),
                      // );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text("Başvur"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApplicationsTab(
    BuildContext context,
    List<Announcement1> allAnnouncements,
    List<Application> applications,
  ) {
    if (applications.isEmpty) {
      return const Center(
        child: Text(
          "Henüz başvurduğunuz bir ilan bulunmamaktadır.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final app = applications[index];
        final ann = allAnnouncements.firstWhere(
          (a) => a.id == app.ilanId,
          orElse:
              () => Announcement1(
                id: app.ilanId,
                title: "Silinmiş İlan",
                description: "",
                kadroTipiId: 0,
                temelAlanId: 0,
                startDate: DateTime.now(),
                endDate: DateTime.now(),
                requiredDocuments: [],
                olusturanAdminId: 0,
                applicationConditions: '',
              ),
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              ann.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Başvuru Tarihi: ${app.basvuruTarihi.toLocal().toString().substring(0, 16)}",
            ),
            trailing: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }

  Widget _infoBox(String title, String value) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(value, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
