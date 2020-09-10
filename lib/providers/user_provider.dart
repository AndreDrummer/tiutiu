import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class UserProvider with ChangeNotifier {
  File _photoFILE;
  String _whatsapp;
  String _telefone;
  String _photoUrl;
  String _displayName;
  DocumentReference _userReference;
  final _betterContact = BehaviorSubject<int>();

  // Listenning to the date
  Stream<int> get betterContact => _betterContact.stream;

  // Getting data
  int get getBetterContact => _betterContact.stream.value;

  // Changing data
  void Function(int) get changeBetterContact => _betterContact.sink.add;

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

  void changeUserReference(DocumentReference userReference) {
    _userReference = userReference;
    notifyListeners();
  }

  File get photoFILE => _photoFILE;
  String get telefone => _telefone;
  String get displayName => _displayName;
  String get photoURL => _photoUrl;
  String get whatsapp => _whatsapp;  
  DocumentReference get userReference => _userReference;  

}