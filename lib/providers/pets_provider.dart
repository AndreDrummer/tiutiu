import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/utils/constantes.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';
import 'package:tiutiu/utils/other_functions.dart';

class PetsProvider with ChangeNotifier {
  final _orderType = BehaviorSubject<String>.seeded('Data de postagem');
  final _petKind = BehaviorSubject<String>.seeded(Constantes.DONATE);
  final _isFilteringByBreed = BehaviorSubject<bool>.seeded(false);
  final _isFilteringByName = BehaviorSubject<bool>.seeded(false);
  final _orderTypeList = BehaviorSubject<List<String>>.seeded(
    [
      'Data de postagem',
      'Nome',
      'Idade',
    ],
  );
  final _petType = BehaviorSubject<String>.seeded('Todos');
  final _typingSearchResult = BehaviorSubject<List<Pet>>();
  final _petsDisappeared = BehaviorSubject<List<Pet>>();
  final _healthSelected = BehaviorSubject<String>();
  final _petsDonate = BehaviorSubject<List<Pet>>();
  final _breedSelected = BehaviorSubject<String>();
  final _sizeSelected = BehaviorSubject<String>();
  final _ageSelected = BehaviorSubject<String>();
  final _sexSelected = BehaviorSubject<String>();
  final _petName = BehaviorSubject<String>();
  bool _isFiltering = false;

  // Listenning to The Data
  Stream<List<Pet>> get typingSearchResult => _typingSearchResult.stream;
  Stream<bool> get isFilteringByBreed => _isFilteringByBreed.stream;
  Stream<List<Pet>> get petsDisappeared => _petsDisappeared.stream;
  Stream<List<String>> get orderTypeList => _orderTypeList.stream;
  Stream<bool> get isFilteringByName => _isFilteringByName.stream;
  Stream<String> get healthSelected => _healthSelected.stream;
  Stream<String> get breedSelected => _breedSelected.stream;
  Stream<String> get sizeSelected => _sizeSelected.stream;
  Stream<List<Pet>> get petsDonate => _petsDonate.stream;
  Stream<String> get ageSelected => _ageSelected.stream;
  Stream<String> get sexSelected => _sexSelected.stream;
  Stream<String> get orderType => _orderType.stream;
  Stream<String> get petName => _petName.stream;
  Stream<String> get petKind => _petKind.stream;
  Stream<String> get petType => _petType.stream;

  // Changing the data
  void Function(String) get changeHealthSelected => _healthSelected.sink.add;
  void Function(String) get changeBreedSelected => _breedSelected.sink.add;
  void Function(String) get changeSizeSelected => _sizeSelected.sink.add;
  void Function(List<Pet>) get changePetsDonate => _petsDonate.sink.add;
  void Function(String) get changeSexSelected => _sexSelected.sink.add;
  void Function(String) get changeAgeSelected => _ageSelected.sink.add;
  void Function(String) get changePetName => _petName.sink.add;
  void Function(String) get changePetKind => _petKind.sink.add;
  void Function(String) get changePetType => _petType.sink.add;
  void Function(List<Pet>) get changePetsDisappeared =>
      _petsDisappeared.sink.add;
  void Function(List<Pet>) get changeTypingSearchResult =>
      _typingSearchResult.sink.add;
  void Function(List<String>) get changeOrderTypeList =>
      _orderTypeList.sink.add;

  void changeOrderType(String text, String state) {
    _orderType.sink.add(text);
    reloadList(state: state);
  }

  // Getting data
  List<Pet> get getTypingSearchResult => _typingSearchResult.value;
  bool get getIsFilteringByBreed => _isFilteringByBreed.value;
  List<Pet> get getPetsDisappeared => _petsDisappeared.value;
  List<String> get getOrderTypeList => _orderTypeList.value;
  bool get getIsFilteringByName => _isFilteringByName.value;
  String get getHealthSelected => _healthSelected.value;
  String get getBreedSelected => _breedSelected.value;
  String get getSizeSelected => _sizeSelected.value;
  List<Pet> get getPetsDonate => _petsDonate.value;
  String get getAgeSelected => _ageSelected.value;
  String get getSexSelected => _sexSelected.value;
  String get getOrderType => _orderType.value;
  String get getPetName => _petName.value;
  String get getPetKind => _petKind.value;
  String get getPetType => _petType.value;
  bool get isFiltering => _isFiltering;

  void changeIsFiltering(bool status) {
    _isFiltering = status;
  }

  void changeIsFilteringByName(bool status) {
    _isFilteringByName.sink.add(status);
  }

  void changeIsFilteringByBreed(bool status) {
    _isFilteringByBreed.sink.add(status);
  }

  Future<void> reloadList({String? state}) async {
    if (getPetKind == Constantes.DONATE) {
      loadDonatePETS(state: state!);
    } else {
      loadDisappearedPETS(state: state!);
    }
  }

  void clearOthersFilters({String? withExceptioOf}) {
    changeHealthSelected('');
    changeBreedSelected('');
    changeSizeSelected('');
    changeAgeSelected('');
    changeSexSelected('');
    changePetType('');
  }

  List<Pet> getPetListFromSnapshots(List<DocumentSnapshot> docs) {
    List<Pet> pets = [];
    for (int i = 0; i < docs.length; i++) {
      pets.add(Pet.fromSnapshot(docs[i]));
    }
    return pets;
  }

  Future<Pet> openPetDetails(String petId, String petKind) async {
    DocumentReference petRef =
        await OtherFunctions.getReferenceById(petId, petKind);
    DocumentSnapshot petSnapshot = await petRef.get();
    Pet petData = Pet.fromSnapshot(petSnapshot);
    return Future.value(petData);
  }

  void loadDonatePETS({String? state}) async {
    if (_isFiltering) {
      loadFilteredPETS(state: state!);
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Constantes.DONATE)
          .where('donated', isEqualTo: false)
          .get();

      List<Pet> pets = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        pets.add(Pet.fromSnapshot(querySnapshot.docs[i]));
      }

      if (state != null) {
        changePetsDonate(
            await OtherFunctions.filterResultsByState(pets, state));
      } else {
        changePetsDonate(pets);
      }
    }
  }

  void loadDisappearedPETS({String? state}) async {
    if (_isFiltering) {
      loadFilteredPETS(state: state!);
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Constantes.DISAPPEARED)
          .where('found', isEqualTo: false)
          .get();

      List<Pet> pets = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        pets.add(Pet.fromSnapshot(querySnapshot.docs[i]));
      }

      if (state != null) {
        changePetsDisappeared(
            await OtherFunctions.filterResultsByState(pets, state));
      } else {
        changePetsDisappeared(pets);
      }
    }
  }

  Stream<QuerySnapshot> loadInfoOrInterested({
    required DocumentReference petReference,
    required String kind,
  }) {
    return kind == Constantes.DONATE
        ? petReference.collection('adoptInteresteds').snapshots()
        : petReference.collection('infoInteresteds').snapshots();
  }

  void increaseViews({
    required DocumentReference petReference,
    required int actualViews,
  }) {
    petReference.set({'views': ++actualViews}, SetOptions(merge: true));
  }

  List<String> _filters() {
    String age = getAgeSelected;
    if (age == 'Mais de 10 anos') {
      age = '10';
    } else if (age == 'Menos de 1 ano') {
      age = '0';
    } else if (age != null && age.isNotEmpty) {
      age = age.split('').first;
    }

    return [
      getPetType,
      getBreedSelected,
      getSizeSelected,
      age,
      getSexSelected,
      getHealthSelected
    ];
  }

  List<String> _filtersType() {
    return ["type", "breed", "size", "ano", "sex", "health"];
  }

  void loadFilteredPETS({String? state}) async {
    Query query = FirebaseFirestore.instance.collection(getPetKind).where(
        getPetKind == Constantes.DONATE ? 'donated' : 'found',
        isEqualTo: false);

    for (int i = 0; i < _filters().length; i++) {
      if (_filters()[i] != null && _filters()[i].isNotEmpty) {
        if (i == 3) {
          if (_filters()[i] == "10") {
          } else if (_filters()[i] == "0") {
            query = query.where(_filtersType()[i],
                isEqualTo: int.tryParse(_filters()[i]) ?? 0);
          } else {
            query = query.where(_filtersType()[i],
                isEqualTo: int.tryParse(_filters()[i]) ?? 0);
          }
        } else {
          query = query.where(_filtersType()[i], isEqualTo: _filters()[i]);
        }
      }
    }

    QuerySnapshot querySnapshot = await query.get();

    List<Pet> pets = [];
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      pets.add(Pet.fromSnapshot(querySnapshot.docs[i]));
    }

    if (state != null) {
      pets = await OtherFunctions.filterResultsByState(pets, state);
    }

    getPetKind == Constantes.DONATE
        ? changePetsDonate(pets)
        : changePetsDisappeared(pets);
  }
}
