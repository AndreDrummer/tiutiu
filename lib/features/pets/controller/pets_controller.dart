import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/ordenators.dart';
import 'package:get/get.dart';

class PetsController extends GetxController {
  PetsController(PetService petService) : _petService = petService;

  PetService _petService;

  final RxBool _isFilteringByName = false.obs;
  final RxInt _petsCount = 0.obs;

  bool get isFilteringByName => _isFilteringByName.value;
  int get petsCount => _petsCount.value;

  void set isFilteringByName(bool value) => _isFilteringByName(value);

  Stream<List<Pet>> petsList({
    bool isFiltering = false,
    bool disappeared = false,
  }) {
    isFilteringByName = isFiltering;

    final petsListStream = _petService.loadPets(
      filterController.filterParams(
        disappeared: disappeared,
      ),
    );

    return petsListStream.asyncMap<List<Pet>>((querySnapshot) {
      return _filterByName(querySnapshot.docs);
    });
  }

  List<Pet> _filterByName(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    List<Pet> petsFilteredByName = [];

    docs.forEach((petSnapshot) {
      final isFilteringByName = filterController.filterByName.isNotEmpty;
      String petName = petSnapshot.data()[PetEnum.name.tostring()];
      petName = petName.toLowerCase();

      final pet = Pet.fromMap(petSnapshot.data());

      if (isFilteringByName) {
        if (petName.contains(filterController.filterByName.toLowerCase())) {
          petsFilteredByName.add(pet);
        }
      } else {
        petsFilteredByName.add(pet);
      }
    });

    _petsCount(petsFilteredByName.length);

    return ordernateList(petsFilteredByName);
  }

  List<Pet> ordernateList(List<Pet> list) {
    if (filterController.orderBy == FilterStrings.distance) {
      list.sort(((a, b) {
        final adADistance =
            Ordenators.orderByDistance(LatLng(a.latitude!, a.longitude!));

        final adBDistance =
            Ordenators.orderByDistance(LatLng(b.latitude!, b.longitude!));

        if (adADistance < adBDistance) return -1;
        if (adADistance > adBDistance) return 1;
        return 0;
      }));
    }

    return list;
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
    petReference.set(
        {PetEnum.views.tostring(): ++actualViews}, SetOptions(merge: true));
  }

  void showInterest({
    required DocumentReference petReference,
    required int actualInteresteds,
  }) {
    petReference.set({
      PetEnum.interesteds.tostring(): ++actualInteresteds,
    }, SetOptions(merge: true));
  }
}
