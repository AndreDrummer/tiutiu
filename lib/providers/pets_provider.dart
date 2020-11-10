import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/backend/Model/pet_model.dart';

class PetsProvider with ChangeNotifier {
  final _petName = BehaviorSubject<String>();
  final _petKind = BehaviorSubject<String>.seeded('Donate');
  final _petType = BehaviorSubject<String>.seeded('Todos');
  final _breedSelected = BehaviorSubject<String>();
  final _sizeSelected = BehaviorSubject<String>();
  final _ageSelected = BehaviorSubject<String>();
  final _sexSelected = BehaviorSubject<String>();
  final _healthSelected = BehaviorSubject<String>();
  final _petsDonate = BehaviorSubject<List<Pet>>();
  final _petsDisappeared = BehaviorSubject<List<Pet>>();
  final _orderType = BehaviorSubject<String>.seeded('Data de postagem');
  final _orderTypeList = BehaviorSubject<List<String>>.seeded(['Data de postagem', 'Nome', 'Idade']);
  bool _isFiltering = false;
  bool _isFilteringByName = false;
  bool _isFilteringByBreed = false;

  // Listenning to The Data
  Stream<String> get petName => _petName.stream;
  Stream<String> get petKind => _petKind.stream;
  Stream<String> get petType => _petType.stream;
  Stream<String> get breedSelected => _breedSelected.stream;
  Stream<String> get sizeSelected => _sizeSelected.stream;
  Stream<String> get ageSelected => _ageSelected.stream;
  Stream<String> get sexSelected => _sexSelected.stream;
  Stream<String> get healthSelected => _healthSelected.stream;
  Stream<List<Pet>> get petsDonate => _petsDonate.stream;
  Stream<List<Pet>> get petsDisappeared => _petsDisappeared.stream;
  Stream<List<String>> get orderTypeList => _orderTypeList.stream;
  Stream<String> get orderType => _orderType.stream;

  // Changing the data
  void Function(String) get changePetName => _petName.sink.add;
  void Function(String) get changePetKind => _petKind.sink.add;
  void Function(String) get changePetType => _petType.sink.add;
  void Function(String) get changeBreedSelected => _breedSelected.sink.add;
  void Function(String) get changeSizeSelected => _sizeSelected.sink.add;
  void Function(String) get changeAgeSelected => _ageSelected.sink.add;
  void Function(String) get changeSexSelected => _sexSelected.sink.add;
  void Function(String) get changeHealthSelected => _healthSelected.sink.add;
  void Function(List<Pet>) get changePetsDonate => _petsDonate.sink.add;
  void Function(List<Pet>) get changePetsDisappeared => _petsDisappeared.sink.add;
  void Function(List<String>) get changeOrderTypeList => _orderTypeList.sink.add;
  
  void changeOrderType(String text) {
    _orderType.sink.add(text);
    reloadList();
  } 

  // Getting data
  String get getPetName => _petName.value;
  String get getPetKind => _petKind.value;
  String get getPetType => _petType.value;
  String get getBreedSelected => _breedSelected.value;
  String get getSizeSelected => _sizeSelected.value;
  String get getAgeSelected => _ageSelected.value;
  String get getSexSelected => _sexSelected.value;
  String get getHealthSelected => _healthSelected.value;
  bool get isFiltering => _isFiltering;  
  bool get isFilteringByName => _isFilteringByName;  
  bool get isFilteringByBreed => _isFilteringByBreed;  
  List<Pet> get getPetsDonate => _petsDonate.value;
  List<Pet> get getPetsDisappeared => _petsDisappeared.value;
  List<String> get getOrderTypeList => _orderTypeList.value;
  String get getOrderType => _orderType.value;

  void changeIsFiltering(bool status) {
    _isFiltering = status;
  }

  void changeIsFilteringByName(bool status) {
    _isFilteringByName = status;
  }

  void changeIsFilteringByBreed(bool status) {
    _isFilteringByBreed = status;
  }

   void reloadList() {
    if (getPetKind == 'Donate') {
      loadDonatePETS();
    } else {
      loadDisappearedPETS();
    }
  }

  void clearOthersFilters({String withExceptioOf}) {
    changePetType('');
    changeBreedSelected('');
    changeSizeSelected('');
    changeAgeSelected('');
    changeSexSelected('');
    changeHealthSelected('');
    changePetsDonate([]);
    changePetsDisappeared([]);
  }

  List<Pet> getPetListFromSnapshots(List<DocumentSnapshot> docs) {
    List<Pet> pets = [];    
    for (int i = 0; i < docs.length; i++) {
      pets.add(Pet.fromSnapshot(docs[i]));
    }
    return pets;
  }

  void loadDonatePETS() async {    
    if(_isFiltering) {
      loadFilteredPETS();
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Donate') .where('donated', isEqualTo: false).get();      
      
      List<Pet> pets = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        pets.add(Pet.fromSnapshot(querySnapshot.docs[i]));
      }
      changePetsDonate(pets);
    }
  }

  void loadDisappearedPETS() async {    
    if(_isFiltering) {
      loadFilteredPETS();
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Disappeared').where('found', isEqualTo: false).get();      
      
      List<Pet> pets = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        pets.add(Pet.fromSnapshot(querySnapshot.docs[i]));
      }
      changePetsDisappeared(pets);
    }
  }

  Stream<QuerySnapshot> loadInfoOrInterested({String kind, DocumentReference petReference}) {
    return kind == 'Donate' ?  petReference.collection('adoptInteresteds').snapshots() : petReference.collection('infoInteresteds').snapshots();
  }

  void increaseViews({int actualViews, DocumentReference petReference}) {
    petReference.set({'views': ++actualViews}, SetOptions(merge: true));
  }
 
  List<String> _filters() {
    String age = getAgeSelected;
    if(age == 'Mais de 10 anos') {
      age = '10';
    } else if(age == 'Menos de 1 ano') {
      age = '0';
    } else if(age != null && age.isNotEmpty) {
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

  void loadFilteredPETS() async {
    Query query = FirebaseFirestore.instance.collection(getPetKind).where(getPetKind == 'Donate' ? 'donated' : 'found', isEqualTo: false);    

    if(isFilteringByName) {
      print(query.parameters);
      query = query.where('name', isEqualTo: getPetName);
    } else if (isFilteringByBreed) {
      query = query.where('breed', isEqualTo: getBreedSelected);
    } else {
      for (int i = 0; i < _filters().length; i++) {
        if (_filters()[i] != null && _filters()[i].isNotEmpty) {        
          if(i == 3) {          
            if(_filters()[i] == "10") {}
            else if(_filters()[i] == "0") {            
              query = query.where(_filtersType()[i], isEqualTo: int.tryParse(_filters()[i]) ?? 0);
            } else {            
              query = query.where(_filtersType()[i], isEqualTo: int.tryParse(_filters()[i]) ?? 0);
            }
          } else {
            query = query.where(_filtersType()[i], isEqualTo: _filters()[i]);
          }
        }
      }
    }    

    QuerySnapshot querySnapshot = await query.get();
    
    List<Pet> pets = [];
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      pets.add(Pet.fromSnapshot(querySnapshot.docs[i]));
    }      

    getPetKind == 'Donate' ? changePetsDonate(pets) : changePetsDisappeared(pets);
  }
}
