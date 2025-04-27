part of '../cubits/manager_cubit.dart';

abstract class YoneticiState {}

class YoneticiInitial extends YoneticiState {}

class YoneticiKriterlerYukleniyor extends YoneticiState {}

class YoneticiBasvurularYukleniyor extends YoneticiState {}

class YoneticiJuriAtamaYukleniyor extends YoneticiState {}

class YoneticiBilgileriYuklendi extends YoneticiState {
  final List<KadroKriter> kriterListesi;
  final List<Basvuru> basvurular;
  final List<JuriIlan> juriIlanListesi;
  final List<JuriKullanicilar> juriKullaniciListesi;
  YoneticiBilgileriYuklendi(this.kriterListesi, this.basvurular, this.juriIlanListesi, this.juriKullaniciListesi);
}

class YoneticiHata extends YoneticiState {
  final String mesaj;

  YoneticiHata(this.mesaj);
}

