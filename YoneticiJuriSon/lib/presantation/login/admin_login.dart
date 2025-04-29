import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/cubits/auth_cubit.dart';
import '../../locator.dart';
import '../../widgets/date_picker_custom.dart';
import '../../widgets/textfield_custom.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final tcController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: getIt<AuthCubit>(),
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            Future.microtask(() => context.go('/home/admin'));
          } else if (state is AuthFailure) {
            Future.microtask(
              () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error))),
            );
          }

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Admin Girişi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: tcController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'TC Kimlik No',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Şifre',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          getIt<AuthCubit>().login(
                            tc: tcController.text,
                            sifre: passController.text,
                          );
                        },
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _showRegisterDialog(context);
                        },
                        child: const Text(
                          'Kayıt Ol',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final tc = TextEditingController();
    final ad = TextEditingController();
    final soyad = TextEditingController();
    final dogumYili = TextEditingController();
    final sifre = TextEditingController();
    final eposta = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kayıt Ol'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldCustom(
                  controller: tc,
                  label: 'TC Kimlik No',
                  type: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextFieldCustom(
                  controller: ad,
                  label: 'Ad',
                  type: TextInputType.name,
                ),
                const SizedBox(height: 8),
                TextFieldCustom(
                  controller: soyad,
                  label: 'Soyad',
                  type: TextInputType.name,
                ),
                const SizedBox(height: 8),
                DatePickerCustom(controller: dogumYili, label: 'Doğum Yılı'),
                const SizedBox(height: 8),
                TextFieldCustom(
                  controller: eposta,
                  label: 'E-posta',
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextFieldCustom(
                  controller: sifre,
                  label: 'Şifre',
                  type: TextInputType.visiblePassword,
                  obscure: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                getIt<AuthCubit>().registerWithSOAP(
                  tc: tc.text,
                  ad: ad.text,
                  soyad: soyad.text,
                  dogumYili: int.parse(dogumYili.text),
                  sifre: sifre.text,
                  eposta: eposta.text,
                  rolId: 2,
                );
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }
  // Widget _buildTextField(TextEditingController controller, String label, TextInputType type, {bool obscure = false}) {
  //   return TextField(
  //     controller: controller,
  //     keyboardType: type,
  //     obscureText: obscure,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       border: const OutlineInputBorder(),
  //     ),
  //   );
  // }

  // Widget _buildDatePickerField(BuildContext context, TextEditingController controller, String label) {
  //   return GestureDetector(
  //     onTap: () async {
  //       final pickedDate = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime(2000),
  //         firstDate: DateTime(1900),
  //         lastDate: DateTime.now(),
  //       );
  //       if (pickedDate != null) {
  //         controller.text = pickedDate.year.toString();
  //       }
  //     },
  //     child: AbsorbPointer(
  //       child: TextField(
  //         controller: controller,
  //         decoration: InputDecoration(
  //           labelText: label,
  //           border: const OutlineInputBorder(),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
