import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:rxdart/rxdart.dart';

class PetsProvider with ChangeNotifier {
  final _listDisappearedPETS = BehaviorSubject<List<Pet>>();
  final _listDonatesPETS = BehaviorSubject<List<Pet>>();
  List<String> allUsersID = [];

  // Listenning to The Data
  Stream<List<Pet>> get listDisappearedPETS => _listDisappearedPETS.stream;
  Stream<List<Pet>> get listDonatesPETS => _listDonatesPETS.stream;

  // Changing the data
  void Function(List<Pet>) get changeListDisappearedPETS =>
      _listDisappearedPETS.sink.add;
  void Function(List<Pet>) get changeListDonatesPETS =>
      _listDonatesPETS.sink.add;

  // Getting data
  List<Pet> get getListDisappearedPETS => _listDisappearedPETS.value;
  List<Pet> get getListDonatesPETS => _listDonatesPETS.value;

  CollectionReference dataBaseCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> loadUsersID() async {
    await dataBaseCollection.get().then(
      (QuerySnapshot allUsers) {
        allUsers.docs.forEach((element) {
          if (!allUsersID.contains(element.id)) allUsersID.add(element.id);
        });
      },
    );
  }

  Future<void> loadDisappearedPETS() async {
    await loadUsersID();
    List<Pet> temp = [];

    for (int j = 0; j < allUsersID.length; j++) {
      await dataBaseCollection
          .doc(allUsersID[j])
          .collection('Pets')
          .doc('posted')
          .collection('Disappeared')
          .where('found', isEqualTo: false)
          .get()
          .then((disappearedPETS) {
        for (int i = 0; i < disappearedPETS.docs.length; i++) {
          temp.add(Pet.fromSnapshot(disappearedPETS.docs[i]));
        }
      });
      changeListDisappearedPETS(temp);
    }

    notifyListeners();
    return Future.value();
  }

  Future<void> loadDonatedPETS() async {
    await loadUsersID();
    List<Pet> temp = [];

    for (int j = 0; j < allUsersID.length; j++) {
      await dataBaseCollection
          .doc(allUsersID[j])
          .collection('Pets')
          .doc('posted')
          .collection('Donate')
          .where('donated', isEqualTo: false)
          .get()
          .then((donatesPETS) {
        for (int i = 0; i < donatesPETS.docs.length; i++) {
          temp.add(Pet.fromSnapshot(donatesPETS.docs[i]));
        }
      });

      print(temp.length);
      changeListDonatesPETS(temp);
    }

    notifyListeners();
    return Future.value();
  }

  Future<void> bigQueryRefine(
    String petKind,
    String petType,
    String breedSelected,
    String sizeSelected,
    String ageSelected,
    String sexSelected,
    String healthSelected,
    String distanceSelected,
  ) async {
    if (petType == 'Todos') {
      if (petKind == 'Donate') {
        loadDonatedPETS();
      } else {
        loadDisappearedPETS();
      }
    } else {
      loadUsersID();
      List<Pet> temp = [];
      for (int j = 0; j < allUsersID.length; j++) {
        var query = await dataBaseCollection
            .doc(allUsersID[j])
            .collection('Pets')
            .doc('posted')
            .collection(petKind)
            .where("type", isEqualTo: petType);

        if (petKind == 'Donate') {
          query = await query.where("donated", isEqualTo: false);
        } else if (petKind == 'Disappeared') {
          query = await query.where("found", isEqualTo: false);
        }        

        if (breedSelected.isNotEmpty && breedSelected != null) {
          query = await query.where("breed", isEqualTo: breedSelected);
        }

        if (sizeSelected.isNotEmpty && sizeSelected != null) {
          query = await query.where("size", isEqualTo: sizeSelected);
        }

        if (ageSelected.isNotEmpty && ageSelected != null) {
          query = await query.where("ano", isEqualTo: int.parse(ageSelected));
        }

        if (sexSelected.isNotEmpty && sexSelected != null) {
          query = await query.where("sex", isEqualTo: sexSelected);
        }

        if (healthSelected.isNotEmpty && healthSelected != null) {
          query = await query.where("health", isEqualTo: healthSelected);
        }

        var result_search = await query.get();
        for (int i = 0; i < result_search.docs.length; i++) {
          temp.add(Pet.fromSnapshot(result_search.docs[i]));
        }
      }

      if (petKind == 'Donate') {
        changeListDonatesPETS(temp);
      } else if (petKind == 'Disappeared') {
        changeListDisappearedPETS(temp);
      }
    }
  }
}
