import 'dart:io';

import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  File _photoFILE;
  String _whatsapp;
  String _telefone;
  String _photoUrl;
  String _displayName;

  void changePhotoFILE(File file) {
    _photoFILE = file;
    notifyListeners();
  }

  void changeWhatsapp(String number) {
    _whatsapp = number;
    notifyListeners();
  }

  void changeDisplayName(String name) {
    _displayName = name;
    notifyListeners();
  }

  void changeTelefone(String number) {
    _telefone = number;
    notifyListeners();
  }

  void changePhotoUrl(String url) {
    _photoUrl = url;
    notifyListeners();
  }

  File get photoFILE => _photoFILE;
  String get telefone => _telefone;
  String get displayName => _displayName;
  String get photoURL => _photoUrl;
  String get whatsapp => _whatsapp;

}