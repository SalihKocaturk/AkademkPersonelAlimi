import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proje1/domain/cubits/auth_cubit.dart';

import '../../domain/cubits/juri_cubit.dart';
import '../../domain/states/juri_state.dart';
import '../../models/juri_model.dart';

class JuryHome extends StatelessWidget {
  const JuryHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const JuryHomePage();
  }
}

class JuryHomePage extends StatefulWidget {
  const JuryHomePage({Key? key}) : super(key: key);

  @override
  State<JuryHomePage> createState() => _JuriHomePageState();
}

class _JuriHomePageState extends State<JuryHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<JuryCubit>().juryBasvurulariGetir();

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jüri Paneli'),
        actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Çıkış Yap',
      onPressed: () {
        context.read<AuthCubit>().logout();
        context.go('/login'); // Ya da anasayfan neresiyse
      },
    ),
  ],
      ),
      body: BlocBuilder<JuryCubit, JuryState>(
        builder: (context, state) {
          if (state is JuryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JuryLoaded) {
            if (state.basvurular.isEmpty) {
              print("deneme");
              return const Center(
                child: Text('Atandığınız bir başvuru bulunmamaktadır.'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.basvurular.length,
              itemBuilder: (context, index) {
                final basvuru = state.basvurular[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    title: Text('${basvuru.adayAd} ${basvuru.adaySoyad}'),
                    subtitle: Text('İlan Başlığı: ${basvuru.ilanBaslik}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showBasvuruDetayDialog(context, basvuru);
                    },
                  ),
                );
              },
            );
          } else if (state is JuryError) {
            return Center(child: Text('Hata: ${state.message}'));
          } else {
            return const Center(child: Text('Veri bulunamadı.'));
          }
        },
      ),
    );
  }

void _showBasvuruDetayDialog(BuildContext context, JuriBasvuru basvuru) {
  final juryCubit = context.read<JuryCubit>();

  String? aciklama;
  bool? karar;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: juryCubit,
        child: StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('📝 Başvuru Değerlendirme'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '👤 Aday: ${basvuru.adayAd}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('📄 Değerlendirme Notu:'),
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) => aciklama = value,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Değerlendirme notunuzu yazınız...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('🏁 Nihai Karar:'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                            },
                            icon: const Icon(
                              Icons.upload_file,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'PDF Yükle',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => setState(() => karar = true),
                                icon: const Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Olumlu',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () => setState(() => karar = false),
                                icon: const Icon(
                                  Icons.thumb_down,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Olumsuz',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      if (karar != null)
                        Text(
                        karar == true ? 'Seçim: Olumlu' : 'Seçim: Olumsuz',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                final authState = context.read<AuthCubit>().state;
if (authState is! AuthLoggedIn) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Giriş yapılmamış. Lütfen tekrar deneyin.')),
  );
  return;
}

                    if (aciklama != null && aciklama!.isNotEmpty && karar != null) {
                      final degerlendirme = JuriDegerlendirmeModel(
                        basvuruID: basvuru.basvuruID,
                        ilanID: basvuru.ilanID,
                        juriUyesiID: authState.kullaniciId,
                        tcKimlikNo:  authState.tc,
                        sonuc: karar!,
                        aciklama: aciklama!,
                        degerlendirmeRaporuYolu: 'https://cloud.com/pdf/rapor.pdf',
                      );
                      print('$karar');
                      juryCubit.degerlendirmeGonder(degerlendirme);
                      Navigator.pop(dialogContext);
                    } else {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Gönder'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
}