import 'package:flutter/material.dart';
import 'package:proje1/widgets/logout_button.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        actions: const [LogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mevcut İlanlar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text("Profesör Kadrosu – Bilgisayar Mühendisliği"),
              subtitle: const Text("01.05.2025 - 20.05.2025"),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Doçent Kadrosu – Elektrik Elektronik"),
              subtitle: const Text("01.05.2025 - 15.05.2025"),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Yeni İlan Ekle"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
