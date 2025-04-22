import 'package:flutter/material.dart';
import 'package:proje1/widgets/logout_button.dart';

class JuryHome extends StatelessWidget {
  const JuryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jüri Paneli'),
        actions: const [LogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aday İnceleme",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text("Aday: Ayşe Yılmaz"),
              subtitle: const Text("Profesör – Bilgisayar Mühendisliği"),
              trailing: const Icon(Icons.visibility),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text("Rapor Yükleme"),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload),
              label: const Text("Rapor Yükle"),
            ),
            const SizedBox(height: 16),
            const Text("Değerlendirme:"),
            DropdownButtonFormField<String>(
              value: null,
              items: const [
                DropdownMenuItem(value: "olumlu", child: Text("Olumlu")),
                DropdownMenuItem(value: "olumsuz", child: Text("Olumsuz")),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
