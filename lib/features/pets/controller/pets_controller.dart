import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PetsController extends GetxController {
  PetsController(PetService petService) : _petService = petService;

  PetService _petService;

  final RxList<Pet> _petsDonate = <Pet>[].obs;
  final RxString _petKind = FirebaseEnvPath.donate.obs;
  final RxList<Pet> _typingSearchResult = <Pet>[].obs;
  final RxList<Pet> _petsDisappeared = <Pet>[].obs;
  final RxBool _isFilteringByBreed = false.obs;
  final RxBool _isFilteringByName = false.obs;
  final RxString _genderSelected = ''.obs;
  final RxString _healthSelected = ''.obs;
  final RxString _orderType = 'Data'.obs;
  final RxString _breedSelected = ''.obs;
  final RxBool _isFiltering = false.obs;
  final RxString _sizeSelected = ''.obs;
  final RxString _petType = 'Todos'.obs;
  final Rx<Pet> petPosting = Pet().obs;
  final RxString _ageSelected = ''.obs;
  final RxList<String> _orderTypeList = [
    'Data',
    'Nome',
    'Idade',
  ].obs;
  final RxString _petName = ''.obs;
  final RxInt _petsCount = 0.obs;

  bool get isFilteringByBreed => _isFilteringByBreed.value;
  List<Pet> get typingSearchResult => _typingSearchResult;
  bool get isFilteringByName => _isFilteringByName.value;
  String get genderSelected => _genderSelected.value;
  String get healthSelected => _healthSelected.value;
  List<Pet> get petsDisappeared => _petsDisappeared;
  String get breedSelected => _breedSelected.value;
  List<String> get orderTypeList => _orderTypeList;
  String get sizeSelected => _sizeSelected.value;
  String get ageSelected => _ageSelected.value;
  bool get isFiltering => _isFiltering.value;
  String get orderType => _orderType.value;
  List<Pet> get petsDonate => _petsDonate;
  int get petsCount => _petsCount.value;
  String get petName => _petName.value;
  String get petKind => _petKind.value;
  String get petType => _petType.value;

  void set typingSearchResult(List<Pet> list) => _typingSearchResult(list);
  void set isFilteringByBreed(bool value) => _isFilteringByBreed(value);
  void set isFilteringByName(bool value) => _isFilteringByName(value);
  void set petsDisappeared(List<Pet> list) => _petsDisappeared(list);
  void set orderTypeList(List<String> list) => _orderTypeList(list);
  void set healthSelected(String value) => _healthSelected(value);
  void set genderSelected(String value) => _genderSelected(value);
  void set breedSelected(String value) => _breedSelected(value);
  void set sizeSelected(String value) => _sizeSelected(value);
  void set isFiltering(bool status) => _isFiltering(status);
  void set ageSelected(String value) => _ageSelected(value);
  void set petsDonate(List<Pet> list) => _petsDonate(list);
  void set petName(String value) => _petName(value);
  void set petKind(String value) => _petKind(value);
  void set petType(String value) => _petType(value);

  void changeOrderType(String text, String state) {
    _orderType(text);
  }

  Stream<List<Pet>> petsList() {
    final stream = _petService.loadPets(filterController.filterParams());

    return stream.asyncMap<List<Pet>>((event) {
      _petsCount(event.docs.length);
      return event.docs.map((el) {
        return Pet.fromMap(el.data());
      }).toList();
    });
  }

  void clearOthersFilters({String? withExceptioOf}) {
    healthSelected = '';
    breedSelected = '';
    sizeSelected = '';
    ageSelected = '';
    genderSelected = '';
    petType = '';
  }

  List<Pet> getPetListFromSnapshots(List<DocumentSnapshot> docs) {
    List<Pet> pets = [];
    for (int i = 0; i < docs.length; i++) {
      pets.add(Pet.fromMap(docs[i].data() as Map<String, dynamic>));
    }
    return pets;
  }

  Future<Pet> openPetDetails(String petId, String petKind) async {
    DocumentReference petRef =
        await OtherFunctions.getReferenceById(petId, petKind);
    DocumentSnapshot petSnapshot = await petRef.get();
    Pet petData = Pet.fromMap(petSnapshot.data() as Map<String, dynamic>);
    return Future.value(petData);
  }

  void loadDisappearedPETS({String? state}) async {
    if (isFiltering) {
      // loadFilteredPETS(state: state!);
    } else {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseEnvPath.disappeared)
          .where('found', isEqualTo: false)
          .get();

      List<Pet> pets = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        pets.add(
          Pet.fromMap(querySnapshot.docs[i].data() as Map<String, dynamic>),
        );
      }

      if (state != null) {
        petsDisappeared =
            await OtherFunctions.filterResultsByState(pets, state);
      } else {
        petsDisappeared = pets;
      }
    }
  }

  Stream<QuerySnapshot> loadInfoOrInterested({
    required DocumentReference petReference,
    required String kind,
  }) {
    return kind == FirebaseEnvPath.donate
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
    String age = ageSelected;
    if (age == 'Mais de 10 anos') {
      age = '10';
    } else if (age == 'Menos de 1 .ageYear') {
      age = '0';
    } else if (age.isNotEmpty) {
      age = age.split('').first;
    }

    return [
      petType,
      breedSelected,
      sizeSelected,
      age,
      genderSelected,
      healthSelected
    ];
  }

  List<String> _filtersType() {
    return ["type", "breed", "size", ".ageYear", "gender", "health"];
  }
}
