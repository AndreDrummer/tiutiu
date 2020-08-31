import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';

class PetsProvider with ChangeNotifier {
  List<Pet> listDisappearedPETS = [];
  List<Pet> listDonatesPETS = [];
  List<String> allUsersID = [];

  CollectionReference dataBaseCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> loadUsersID() async {
    allUsersID.clear();
    await dataBaseCollection.get().then(
      (QuerySnapshot allUsers) {
        allUsers.docs.forEach((element) {
          allUsersID.add(element.id);
        });
      },
    );
  }

  Future<void> loadDisappearedPETS() async {
    await loadUsersID();
    listDisappearedPETS.clear();

    for (int j = 0; j < allUsersID.length; j++) {
      await dataBaseCollection
          .doc(allUsersID[j])
          .collection('Pets')
          .doc('pets')
          .collection('Disappeared')
          .get()
          .then((disappearedPETS) {
        for (int i = 0; i < disappearedPETS.docs.length; i++) {
          listDisappearedPETS.add(Pet.fromSnapshot(disappearedPETS.docs[i]));
        }
        print('${listDisappearedPETS.length} Disap');
      });
    }

    notifyListeners();
    return Future.value();
  }

  Future<void> loadDonatedPETS() async {
    await loadUsersID();
    listDonatesPETS.clear();

    for (int j = 0; j < allUsersID.length; j++) {
      await dataBaseCollection
          .doc(allUsersID[j])
          .collection('Pets')
          .doc('pets')
          .collection('Donate')
          .get()
          .then((donatesPETS) {
        for (int i = 0; i < donatesPETS.docs.length; i++) {
          listDonatesPETS.add(Pet.fromSnapshot(donatesPETS.docs[i]));
        }
        print('${listDonatesPETS.length} Donate');
      });
    }

    notifyListeners();
    return Future.value();
  }
}
