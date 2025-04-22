import 'package:flutter/material.dart';
import 'package:proje1/widgets/logout_button.dart';

class ManagerHome extends StatelessWidget {
  const ManagerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetici Paneli'),
        actions: const [LogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Başvuru Kriterleri",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Doçent – Elektrik Elektronik"),
              subtitle: const Text("En az 3 yayın, 1 başlıca yazarlık"),
              trailing: const Icon(Icons.tune),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Prof. – Bilgisayar Mühendisliği"),
              subtitle: const Text(
                "A1-A5 arası 4 yayın, 1 tanesi A1/A2 zorunlu",
              ),
              trailing: const Icon(Icons.tune),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text(
              "PDF Üretimi ve Tablo 5 Otomasyonu",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Tablo 5 PDF Oluştur"),
            ),
          ],
        ),
      ),
    );
  }
}
