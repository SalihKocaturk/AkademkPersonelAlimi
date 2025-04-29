part of '../cubits/auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthLoggedIn extends AuthState {
  final String rol;
  final String ad;
  final String soyad;
  final String tc;
  AuthLoggedIn({
    required this.rol,
    required this.ad,
    required this.soyad,
    required this.tc,
  });
}
