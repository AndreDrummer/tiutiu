import 'dart:io';

import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  File _photoURL;
  String _whatsapp;
  String _telefone;

  void changePhotoURL(File file) {
    _photoURL = file;
    notifyListeners();
  }

  void changeWhatsapp(String number) {
    _whatsapp = number;
    notifyListeners();
  }

  void changeTelefone(String number) {
    _telefone = number;
    notifyListeners();
  }

  File get photoURL => _photoURL;
  String get telefone => _telefone;
  String get whatsapp => _whatsapp;

}