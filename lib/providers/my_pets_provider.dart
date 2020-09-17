import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';

class MyPetsProvider with ChangeNotifier {
  final _myPets = BehaviorSubject<List>();

  Stream<List> get myPets => _myPets.stream;

  List get getMyPets => _myPets.stream.value;

  void Function(List) get changeMyPets => _myPets.sink.add;

  Future<void> loadMyPets(String uid) async {
    List temp = [];

    final donates = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Pets')
        .doc('posted')
        .collection('Donate')
        .get();     

    final disappeared = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Pets')
        .doc('posted')
        .collection('Donate')
        .get();

    for(int i = 0; i < donates.docs.length; i++) {
      temp.add(Pet.fromSnapshot(donates.docs[i]));
    }

    for(int i = 0; i < disappeared.docs.length; i++) {
      temp.add(Pet.fromSnapshot(disappeared.docs[i]));
    }          
    
    changeMyPets(temp);
    notifyListeners();
  }

}