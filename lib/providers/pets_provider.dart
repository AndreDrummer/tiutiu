import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';

class PetsProvider with ChangeNotifier {
  List<Pet> listDisappearedPETS = [];
  List<String> allUsersID = [];
  
  CollectionReference dataBaseCollection = Firestore.instance.collection('Users');

  void loadUsersID(String userId) {
    dataBaseCollection.getDocuments().then(
      (QuerySnapshot allUsers) {
        allUsers.documents.forEach((element) {
          allUsersID.add(element.documentID);
        });
      },
    );
  }

  void loadDisappearedPETS() {    
    allUsersID.forEach((currentUserID) {
      dataBaseCollection
      .document(currentUserID)
      .collection('Pets')
      .document('pets')
      .collection('Disappeard')
      .getDocuments().then((disappearedPETS) => {
        disappearedPETS.documents.forEach((element) {
          listDisappearedPETS.add(Pet.fromSnapshot(element));
        })
      });
    });
  }
}
