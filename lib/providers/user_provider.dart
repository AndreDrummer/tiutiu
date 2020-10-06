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
  String _createdAt;
  DocumentReference _userReference;
  final _betterContact = BehaviorSubject<int>();
  final _totaToDonate = BehaviorSubject<int>.seeded(0);
  final _totalDonated = BehaviorSubject<int>.seeded(0);
  final _totalAdopted = BehaviorSubject<int>.seeded(0);
  final _totalDisappeared = BehaviorSubject<int>.seeded(0);
  final _allPets = BehaviorSubject<List<Pet>>();
  final _donatePets = BehaviorSubject<List<Pet>>();
  final _disappearedPets = BehaviorSubject<List<Pet>>();

  // Listenning to the date
  Stream<int> get betterContact => _betterContact.stream;
  Stream<int> get totalToDonate => _totaToDonate.stream;
  Stream<int> get totalDonated => _totalDonated.stream;
  Stream<int> get totalAdopted => _totalAdopted.stream;
  Stream<int> get totalDisappeared => _totalDisappeared.stream;
  Stream<List<Pet>> get allPets => _allPets.stream;
  Stream<List<Pet>> get donatePets => _donatePets.stream;
  Stream<List<Pet>> get disappearedPets => _disappearedPets.stream;

  // Getting data
  int get getBetterContact => _betterContact.stream.value;
  int get getTotalToDonate => _totaToDonate.stream.value;
  int get getTotalDonated => _totalDonated.stream.value;
  int get getTotalAdopted => _totalAdopted.stream.value;
  int get getTotalDisappeared => _totalDisappeared.stream.value;
  List<Pet> get getAllPets => _allPets.stream.value;
  List<Pet> get getDonatePets => _donatePets.stream.value;
  List<Pet> get getDisappearedPets => _disappearedPets.stream.value;

  // Changing data
  void Function(int) get changeBetterContact => _betterContact.sink.add;
  void Function(int) get changeTotalToDonate => _totaToDonate.sink.add;
  void Function(int) get changeTotalDonated => _totalDonated.sink.add;
  void Function(int) get changeTotalAdopted => _totalAdopted.sink.add;
  void Function(int) get changeTotalDisappeared => _totalDisappeared.sink.add;
  void Function(List<Pet>) get changeAllPets => _allPets.sink.add;
  void Function(List<Pet>) get changeDonatePets => _donatePets.sink.add;
  void Function(List<Pet>) get changeDisappearedPets => _disappearedPets.sink.add;

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
  
  void changeCreatedAt(String createdAt) {
    _createdAt = createdAt;
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

  File get photoFILE => _photoFILE;
  String get telefone => _telefone;
  String get displayName => _displayName;
  String get createdAt => _createdAt;
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
    changeTotalToDonate(donates.docs.length);      
  }

  Future<void> loadMyPets({String kind}) async {
    PetController petController = PetController();
    if(kind == null) {
      changeAllPets(await petController.getAllPetsByKind(uid));    
    } else if (kind == 'Donate') {
      print('Kind: $kind');
      changeDonatePets(await petController.getAllPetsByKind(uid, kind: kind));    
    } else {
      changeDisappearedPets(await petController.getAllPetsByKind(uid, kind: kind));    
    }
  }

}