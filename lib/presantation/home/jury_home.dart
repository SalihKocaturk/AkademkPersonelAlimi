import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/juri_cubit.dart';

class JuriPanelEkrani extends StatelessWidget {
  const JuriPanelEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => JuriCubit(),
      child: const JuriPanelBody(),
    );
  }
}

class JuriPanelBody extends StatefulWidget {
  const JuriPanelBody({super.key});

  @override
  State<JuriPanelBody> createState() => _JuriPanelBodyState();
}

class _JuriPanelBodyState extends State<JuriPanelBody> {
  final _notController = TextEditingController();
  // ignore: prefer_final_fields
  String _mockAdayAdi = 'Dr. Zeynep Karaca';
  // ignore: prefer_final_fields
  String _mockKadro = 'Doçent';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jüri Paneli')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<JuriCubit, JuriState>(
          listener: (context, state) {
            if (state is JuriDegerlendirmeEksik) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.mesaj)),
              );
            }
            if (state is JuriDegerlendirmeTamamlandi) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Tamamlandı'),
                  content: const Text('Değerlendirme başarıyla gönderildi.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kapat'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return ListView(
              children: [
                Text('🧑‍🎓 Aday: $_mockAdayAdi', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('📌 Kadro Türü: $_mockKadro'),
                const SizedBox(height: 16),

                const Text('📄 Açıklamanız'),
                TextField(
                  controller: _notController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Aday hakkında değerlendirme notunuzu yazın...',
                  ),
                  onChanged: (val) => context.read<JuriCubit>().notGuncelle(val),
                ),
                const SizedBox(height: 16),

                const Text('✅ Nihai Karar'),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.thumb_up),
                      label: const Text('Olumlu'),
                      onPressed: () {
                        context.read<JuriCubit>().kararGuncelle(true);
                      },
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.thumb_down),
                      label: const Text('Olumsuz'),
                      onPressed: () {
                        context.read<JuriCubit>().kararGuncelle(false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('PDF Raporu Yükle (Mock)'),
                  onPressed: () {
                    context.read<JuriCubit>().dosyaYukle('mock/path/rapor.pdf');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dosya yüklendi (mock)')),
                    );
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  onPressed: () {
                    context.read<JuriCubit>().tamamlaDegerlendirme();
                  },
                  child: const Text('Değerlendirmeyi Gönder'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
