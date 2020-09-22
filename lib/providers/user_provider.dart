import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';

class UserProvider with ChangeNotifier {
  File _photoFILE;
  String _whatsapp;
  String _telefone;
  String _photoUrl;
  String _photoBack;
  String _uid;
  String _displayName;
  DocumentReference _userReference;
  final _betterContact = BehaviorSubject<int>();
  final _totalDonated = BehaviorSubject<int>();
  final _totalAdopted = BehaviorSubject<int>();
  final _totalDisappeared = BehaviorSubject<int>();
  final _myPetsList = BehaviorSubject<List<Pet>>();

  // Listenning to the date
  Stream<int> get betterContact => _betterContact.stream;
  Stream<int> get totalDonated => _totalDonated.stream;
  Stream<int> get totalAdopted => _totalAdopted.stream;
  Stream<int> get totalDisappeared => _totalDisappeared.stream;
  Stream<List<Pet>> get myPets => _myPetsList.stream;

  // Getting data
  int get getBetterContact => _betterContact.stream.value;
  int get getTotalDonated => _totalDonated.stream.value;
  int get getTotalAdopted => _totalAdopted.stream.value;
  int get getTotalDisappeared => _totalDisappeared.stream.value;
  List<Pet> get getMyPets => _myPetsList.stream.value;

  // Changing data
  void Function(int) get changeBetterContact => _betterContact.sink.add;
  void Function(int) get changeTotalDonated => _totalDonated.sink.add;
  void Function(int) get changeTotalAdopted => _totalAdopted.sink.add;
  void Function(int) get changeTotalDisappeared => _totalDisappeared.sink.add;
  void Function(List<Pet>) get changePets => _myPetsList.sink.add;

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

  void changePhotoBack(String back) {
    _photoBack = back;
    notifyListeners();
  }

  void changeUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void changeUserReference(DocumentReference userReference) {
    _userReference = userReference;
    notifyListeners();
  }

  Future<bool> thisPetIsMine(DocumentReference userRef) async {
    final user = await userRef.get();    
    return user.data()['uid'] == uid;
  }

  File get photoFILE => _photoFILE;
  String get telefone => _telefone;
  String get displayName => _displayName;
  String get photoURL => _photoUrl;
  String get photoBACK => _photoBack;
  String get whatsapp => _whatsapp;  
  String get uid => _uid;
  DocumentReference get userReference => _userReference;

  void calculateTotals() async {    
    PetController petController = PetController();
    QuerySnapshot donates = await petController.getPet(uid, 'Donate');
    QuerySnapshot disap = await petController.getPet(uid, 'Disappeared');

    changeTotalDisappeared(disap.docs.length);
    changeTotalDonated(donates.docs.length);      
  }

  Future<void> loadMyPets() async {
    PetController petController = PetController();
    changePets(await petController.getAllPets(uid));    
  }

}