import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  setupLocators();
  runApp(const MyApp());
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
