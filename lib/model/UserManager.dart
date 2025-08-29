import 'ogrenci_bilgileri.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();
  factory UserManager() => _instance;
  UserManager._internal();

  Map<String, dynamic> users = {};
  OgrenciBilgileri? ogrenciBilgileri;
}
