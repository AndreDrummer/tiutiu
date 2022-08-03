import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/backend/Controller/pet_controller.dart';
import 'package:tiutiu/backend/Controller/user_controller.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/backend/Model/user_model.dart' as userModel;

class UserProvider with ChangeNotifier {
  bool recentlyAuthenticated = false;
  DocumentReference? _userReference;
  String? _notificationToken;
  String? _displayName;
  String? _photoBack;
  String? _whatsapp;
  String? _telefone;
  String? _photoUrl;
  String? _createdAt;
  File? _photoFILE;
  String? _uid;

  final _isGeneratingSharedLink = BehaviorSubject<bool>.seeded(false);
  final _totalDisappeared = BehaviorSubject<int>.seeded(0);
  final _betterContact = BehaviorSubject<int>.seeded(0);
  final _disappearedPets = BehaviorSubject<List<Pet>>();
  final _totaToDonate = BehaviorSubject<int>.seeded(0);
  final _totalDonated = BehaviorSubject<int>.seeded(0);
  final _totalAdopted = BehaviorSubject<int>.seeded(0);
  final _newMessages = BehaviorSubject<int>.seeded(0);
  final _adoptedPets = BehaviorSubject<List<Pet>>();
  final _donatedPets = BehaviorSubject<List<Pet>>();
  final _donatePets = BehaviorSubject<List<Pet>>();
  final _allPets = BehaviorSubject<List<Pet>>();
  final _notifications = BehaviorSubject<int>();

  // Listenning to the date
  Stream<bool> get isGeneratingSharedLink => _isGeneratingSharedLink.stream;
  Stream<List<Pet>> get disappearedPets => _disappearedPets.stream;
  Stream<int> get totalDisappeared => _totalDisappeared.stream;
  Stream<List<Pet>> get adoptedPets => _adoptedPets.stream;
  Stream<List<Pet>> get donatedPets => _donatedPets.stream;
  Stream<List<Pet>> get donatePets => _donatePets.stream;
  Stream<int> get notifications => _notifications.stream;
  Stream<int> get betterContact => _betterContact.stream;
  Stream<int> get totalToDonate => _totaToDonate.stream;
  Stream<int> get totalDonated => _totalDonated.stream;
  Stream<int> get totalAdopted => _totalAdopted.stream;
  Stream<int> get newMessages => _newMessages.stream;
  Stream<List<Pet>> get allPets => _allPets.stream;

  // Getting data
  bool get getIsGeneratingSharedLink => _isGeneratingSharedLink.value;
  List<Pet> get getDisappearedPets => _disappearedPets.stream.value;
  int get getTotalDisappeared => _totalDisappeared.stream.value;
  List<Pet> get getDonatedPets => _donatedPets.stream.value;
  List<Pet> get getAdoptedPets => _adoptedPets.stream.value;
  int get getBetterContact => _betterContact.stream.value;
  List<Pet> get getDonatePets => _donatePets.stream.value;
  int get getNotifications => _notifications.stream.value;
  int get getTotalToDonate => _totaToDonate.stream.value;
  int get getTotalDonated => _totalDonated.stream.value;
  int get getTotalAdopted => _totalAdopted.stream.value;
  int get getNewMessages => _newMessages.stream.value;
  List<Pet> get getAllPets => _allPets.stream.value;

  // Changing data
  void Function(int) get changeTotalDisappeared => _totalDisappeared.sink.add;
  void Function(List<Pet>) get changeAdoptedPets => _adoptedPets.sink.add;
  void Function(List<Pet>) get changeDonatedPets => _donatedPets.sink.add;
  void Function(int) get changeBetterContact => _betterContact.sink.add;
  void Function(List<Pet>) get changeDonatePets => _donatePets.sink.add;
  void Function(int) get changeTotalToDonate => _totaToDonate.sink.add;
  void Function(int) get changeTotalDonated => _totalDonated.sink.add;
  void Function(int) get changeTotalAdopted => _totalAdopted.sink.add;
  void Function(int) get changeNewMessages => _newMessages.sink.add;
  void Function(List<Pet>) get changeAllPets => _allPets.sink.add;
  void Function(List<Pet>) get changeDisappearedPets =>
      _disappearedPets.sink.add;
  void Function(bool) get changeIsGeneratingSharedLink =>
      _isGeneratingSharedLink.sink.add;

  void changeNotifications(int list) {
    _notifications.sink.add(list);
    notifyListeners();
  }

  void changePhotoFILE(File? file) {
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

  void changeNotificationToken(String notificationToken) {
    _notificationToken = notificationToken;
    notifyListeners();
  }

  void changeUserReference(DocumentReference? userReference) {
    _userReference = userReference!;
    notifyListeners();
  }

  void changeRecentlyAuthenticated(bool status) {
    recentlyAuthenticated = status;
    notifyListeners();
  }

  DocumentReference? get userReference => _userReference;
  String? get notificationToken => _notificationToken;
  String? get displayName => _displayName;
  String? get createdAt => _createdAt;
  String? get photoBACK => _photoBack;
  String? get photoURL => _photoUrl;
  String? get whatsapp => _whatsapp;
  File? get photoFILE => _photoFILE;
  String? get telefone => _telefone;
  String? get uid => _uid;

  void calculateTotals() async {
    PetController petController = PetController();
    QuerySnapshot adopteds =
        await petController.getPetToCount(userReference!, Constantes.ADOPTED);
    QuerySnapshot donates =
        await petController.getPetToCount(userReference!, Constantes.DONATE);
    QuerySnapshot disap = await petController.getPetToCount(
        userReference!, Constantes.DISAPPEARED);
    QuerySnapshot donated = await petController
        .getPetToCount(userReference!, Constantes.DONATE, avalaible: false);

    changeTotalDisappeared(disap.docs.length);
    changeTotalAdopted(adopteds.docs.length);
    changeTotalToDonate(donates.docs.length);
    changeTotalDonated(donated.docs.length);
    notifyListeners();
  }

  Stream<QuerySnapshot> adoptionToConfirm() {
    PetController petController = PetController();
    return petController.getAdoptionsToConfirm(uid!);
  }

  Future<void> handleNotifications(data) async {
    UserController userController = UserController();
    Map<String, dynamic> notificationData = {};
    String userThatWillReceiveNotification = '';

    switch (data['notificationType']) {
      case 'wannaAdopt':
        notificationData.putIfAbsent(
            'userReference', () => data['userReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Quero adotar!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} tem interesse na adoção de ${data['petName']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'petInfo':
        notificationData.putIfAbsent(
            'userReference', () => data['userReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent(
            'title', () => 'Informações sobre seu PET desaparecido!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} viu seu PET próximo a localização dele.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'adoptionDeny':
        notificationData.putIfAbsent(
            'userReference', () => data['interestedReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Adoção NÃO confirmada!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} negou que tenha adotado ${data['name']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'adoptionConfirmed':
        notificationData.putIfAbsent(
            'userReference', () => data['interestedReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Adoção confirmada!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['interestedName']} confirmou a adoção de ${data['name']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['ownerID'];
        break;
      case 'confirmAdoption':
        notificationData.putIfAbsent(
            'userReference', () => data['ownerReference']);
        notificationData.putIfAbsent(
            'notificationType', () => data['notificationType']);
        notificationData.putIfAbsent(
            'petReference', () => data['petReference']);
        notificationData.putIfAbsent(
            'time', () => DateTime.now().toIso8601String());
        notificationData.putIfAbsent('title', () => 'Confirme adoção!');
        notificationData.putIfAbsent(
            'message',
            () =>
                '${data['ownerName']} pediu que você confirme a adoção de ${data['name']}.');
        notificationData.putIfAbsent('open', () => false);
        userThatWillReceiveNotification = data['interestedID'];
        break;
    }

    print('NOTIFICATION ${data['notificationType']}');

    if (data['notificationType'] != 'chatNotification') {
      String notificationId = data['petReference']['_path']['segments'][1];
      await userController.createNotification(
          userId: userThatWillReceiveNotification,
          data: notificationData,
          notificationId: notificationId);
    }
  }

  Stream<QuerySnapshot> loadNotifications() {
    UserController userController = UserController();
    return userController.loadNotifications(uid!);
  }

  void clearUserDataOnSignOut() {
    changeUserReference(null);
    changeWhatsapp('');
    changePhotoUrl('');
    changePhotoFILE(null);
    changeTelefone('');
    changeTotalAdopted(0);
    changeTotalDisappeared(0);
    changeTotalDonated(0);
    changeTotalToDonate(0);
  }

  userModel.User user() {
    return userModel.User(
      password: '',
      createdAt: createdAt,
      email: FirebaseAuth.instance.currentUser!.email,
      id: uid,
      betterContact: getBetterContact,
      photoBACK: photoBACK,
      landline: telefone,
      name: displayName,
      notificationToken: notificationToken,
      photoURL: photoURL,
      phoneNumber: whatsapp,
    );
  }
}
