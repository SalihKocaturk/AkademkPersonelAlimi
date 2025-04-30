import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proje1/application/candidate_application.dart';
import 'package:proje1/domain/cubits/auth_cubit.dart';
import 'package:proje1/domain/cubits/juri_cubit.dart';
import 'package:proje1/locator.dart';
import 'package:proje1/presantation/home/admin_home.dart';
import 'package:proje1/presantation/home/candidate_home.dart';
import 'package:proje1/presantation/home/jury_home.dart';
import 'package:proje1/presantation/home/manager_home.dart';
import 'package:proje1/presantation/login/role_selector.dart';

import 'presantation/login/admin_login.dart';
import 'presantation/login/candidate_login.dart';
import 'presantation/login/jury_login.dart';
import 'presantation/login/manager_login.dart';

void main() {
  setupLocators(); // getIt

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<JuryCubit>()),
      ],
      child: MyApp(),
    ),
  );
}


final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const RoleSelector()),
    GoRoute(
      path: '/login/candidate',
      builder: (context, state) => const CandidateLogin(),
    ),
    GoRoute(
      path: '/login/jury',
      builder: (context, state) => const JuryLogin(),
    ),
    GoRoute(
      path: '/login/admin',
      builder: (context, state) => const AdminLogin(),
    ),
    GoRoute(
      path: '/login/manager',
      builder: (context, state) => const ManagerLogin(),
    ),
    GoRoute(
      path: '/home/candidate',
      builder: (context, state) => const CandidateHome(),
    ),
    GoRoute(path: '/home/admin', builder: (context, state) => AdminHome()),
    GoRoute(
      path: '/home/manager',
      builder: (context, state) => const ManagerHome(),
    ),
    GoRoute(path: '/home/jury', builder: (context, state) => const JuryHome()),
    GoRoute(
      path: '/applications/candidate',
      name: 'candidateApplication',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>?;

        final adSoyad = extra?['adSoyad'] ?? '';
        final ilanBaslik = extra?['ilanBaslik'] ?? '';

        return CandidateApplication(adSoyad: adSoyad, ilanBaslik: ilanBaslik);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Akademik Başvuru',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
