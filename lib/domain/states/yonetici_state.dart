import '../models/yonetici_model.dart';

abstract class YoneticiState {}

class YoneticiInitial extends YoneticiState {}

class YoneticiYukleniyor extends YoneticiState {}

class YoneticiYuklendi extends YoneticiState {
  final List<KadroKriter> kriterListesi;

  YoneticiYuklendi(this.kriterListesi);
}

class YoneticiHata extends YoneticiState {
  final String mesaj;

  YoneticiHata(this.mesaj);
}
