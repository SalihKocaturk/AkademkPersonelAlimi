import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/cubits/juri_cubit.dart';

class JuryHome extends StatelessWidget {
  const JuryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JuriCubit(),
      child: const JuriPanelBody(),
    );
  }
}

class MockBasvuru {
  final String adayAdi;
  final String kadro;
  final List<String> makaleDosyalari;

  MockBasvuru({required this.adayAdi, required this.kadro, required this.makaleDosyalari});
}

final List<MockBasvuru> mockBasvurular = [
  MockBasvuru(adayAdi: 'Dr. Zeynep Karaca', kadro: 'Doçent', makaleDosyalari: [
    'makale_a1.pdf',
    'makale_b2.pdf'
  ]),
  MockBasvuru(adayAdi: 'Dr. Ahmet Demir', kadro: 'Profesör', makaleDosyalari: [
    'makale_c1.pdf',
    'makale_d1.pdf'
  ]),
];

class JuriPanelBody extends StatefulWidget {
  const JuriPanelBody({super.key});

  @override
  State<JuriPanelBody> createState() => _JuriPanelBodyState();
}

class _JuriPanelBodyState extends State<JuriPanelBody> {
  int _seciliIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jüri Paneli'),
        leading: _seciliIndex != -1
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _seciliIndex = -1),
              )
            : null,
      ),
      body: _seciliIndex == -1
          ? ListView.builder(
              itemCount: mockBasvurular.length,
              itemBuilder: (context, index) {
                final basvuru = mockBasvurular[index];
                return ListTile(
                  leading: const Icon(Icons.assignment_ind),
                  title: Text(basvuru.adayAdi),
                  subtitle: Text('Kadro: ${basvuru.kadro}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => setState(() => _seciliIndex = index),
                );
              },
            )
          : DegerlendirmeSayfasi(basvuru: mockBasvurular[_seciliIndex]),
    );
  }
}

class DegerlendirmeSayfasi extends StatelessWidget {
  final MockBasvuru basvuru;
  const DegerlendirmeSayfasi({super.key, required this.basvuru});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('degerlendirme'),
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('🧑‍🎓 Aday: ${basvuru.adayAdi}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('📌 Kadro Türü: ${basvuru.kadro}'),
          const SizedBox(height: 16),

          const Text('📄 Yüklenen Makaleler:'),
          ...basvuru.makaleDosyalari.map((dosya) => ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: Text(dosya),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$dosya indirildi (mock)')),
                    );
                  },
                ),
              )),

          const SizedBox(height: 16),
          const Text('📄 Açıklama'),
          TextField(
            maxLines: 4,
            onChanged: (val) => context.read<JuriCubit>().notGuncelle(val),
            decoration: const InputDecoration(
              hintText: 'Değerlendirme notu...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('✅ Nihai Karar'),
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.thumb_up),
                label: const Text('Olumlu'),
                onPressed: () => context.read<JuriCubit>().kararGuncelle(true),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.thumb_down),
                label: const Text('Olumsuz'),
                onPressed: () => context.read<JuriCubit>().kararGuncelle(false),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () => context.read<JuriCubit>().tamamlaDegerlendirme(),
            child: const Text('Değerlendirmeyi Gönder'),
          ),
        ],
      ),
    );
  }
}
