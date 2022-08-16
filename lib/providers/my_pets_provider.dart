import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';

class MyPetsProvider with ChangeNotifier {
  final _myPets = BehaviorSubject<List>();

  Stream<List> get myPets => _myPets.stream;

  List get getMyPets => _myPets.stream.value;

  void Function(List) get changeMyPets => _myPets.sink.add;

  Future<void> loadMyPostedPets(String uid) async {
    List temp = [];

    final donates = await FirebaseFirestore.instance
        .collection(FirebaseEnvPath.users)
        .doc(uid)
        .collection('Pets')
        .doc('posted')
        .collection(FirebaseEnvPath.donate)
        .get();

    final disappeared = await FirebaseFirestore.instance
        .collection(FirebaseEnvPath.users)
        .doc(uid)
        .collection('Pets')
        .doc('posted')
        .collection(FirebaseEnvPath.donate)
        .get();

    for (int i = 0; i < donates.docs.length; i++) {
      temp.add(Pet.fromSnapshot(donates.docs[i]));
    }

    for (int i = 0; i < disappeared.docs.length; i++) {
      temp.add(Pet.fromSnapshot(disappeared.docs[i]));
    }

    changeMyPets(temp);
    notifyListeners();
  }
}
