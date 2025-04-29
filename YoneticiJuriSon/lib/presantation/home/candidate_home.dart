import 'package:flutter/material.dart';
import 'package:proje1/widgets/logout_button.dart';

class CandidateHome extends StatelessWidget {
  const CandidateHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> staticAds = [
      {
        "title": "Profesör Kadrosu – Bilgisayar Mühendisliği",
        "date": "01.05.2025 - 20.05.2025",
        "criteria": "A1-A5'ten en az 4 yayın, 1 tanesi A1/A2 zorunlu",
      },
      {
        "title": "Doçent Kadrosu – Elektrik Elektronik Mühendisliği",
        "date": "01.05.2025 - 15.05.2025",
        "criteria": "En az 3 yayın, başlıca yazar olduğu makale olmalı",
      },
      {
        "title": "Dr. Öğr. Üyesi Kadrosu – Yazılım Mühendisliği",
        "date": "05.05.2025 - 25.05.2025",
        "criteria": "A1-A4 arasında en az 3 yayın, en az 1 başlıca yazarlık",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aday Paneli'),
        actions: const [LogoutButton()],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: staticAds.length,
        itemBuilder: (context, index) {
          final ad = staticAds[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Başvuru Tarihleri: ${ad["date"]}"),
                  const SizedBox(height: 4),
                  Text("Kriter: ${ad["criteria"]}"),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {}, // başvuru sayfasına yönlendirilebilir
                      child: const Text("Başvur"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
