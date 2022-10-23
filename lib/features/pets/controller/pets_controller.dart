import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/ordenators.dart';
import 'package:get/get.dart';

class PetsController extends GetxController {
  PetsController(PostService postService) : _postService = postService;

  PostService _postService;

  final RxString _orderParam = FilterStrings.distance.obs;
  final RxBool _isFilteringByName = false.obs;
  final RxString _loadingText = ''.obs;
  final RxBool _isLoading = false.obs;
  final Rx<Pet> _pet = Pet().obs;
  final RxInt _petsCount = 0.obs;

  bool get isFilteringByName => _isFilteringByName.value;
  String get loadingText => _loadingText.value;
  String get orderParam => _orderParam.value;
  bool get isLoading => _isLoading.value;
  int get petsCount => _petsCount.value;
  Pet get pet => _pet.value;

  void set loadingText(String text) => _loadingText(text);
  void set isLoading(bool value) => _isLoading(value);
  void set pet(Pet pet) => _pet(pet);

  void updatePet(PetEnum property, dynamic data) {
    final petMap = pet.toMap();
    petMap[property.name] = data;

    final updatedPet = Pet().fromMap(petMap);
    pet = updatedPet;
  }

  Stream<List<Pet>> petsList({
    bool isFilteringByName = false,
    bool disappeared = false,
    String? orderParam,
  }) {
    _isFilteringByName(isFilteringByName);
    _orderParam(orderParam);

    final petsListStream = _postService.loadPets(
      filterController.filterParams(
        disappeared: disappeared,
      ),
    );

    return petsListStream.asyncMap<List<Pet>>((querySnapshot) {
      return _filterdResult(querySnapshot.docs);
    });
  }

  Stream<List<Pet>> teste() {
    return Stream.value(<Pet>[]);
  }

  List<Pet> _filterdResult(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    List<Pet> petsFilteredByName = [];

    docs.forEach((petSnapshot) {
      final isFilteringByName = filterController.filterByName.isNotEmpty;
      String petName = petSnapshot.data()[PetEnum.name.name];
      petName = petName.toLowerCase();

      final pet = Pet().fromMap(petSnapshot.data());

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
    if (orderParam == FilterStrings.distance) {
      list.sort(Ordenators.orderByDistance);
    } else if (orderParam == FilterStrings.date) {
      list.sort(Ordenators.orderByPostDate);
    } else if (orderParam == FilterStrings.age) {
      list.sort(Ordenators.orderByAge);
    } else if (orderParam == FilterStrings.name) {
      list.sort(Ordenators.orderByName);
    }

    return list;
  }

  List<Pet> getPetListFromSnapshots(List<DocumentSnapshot> docs) {
    List<Pet> pets = [];
    for (int i = 0; i < docs.length; i++) {
      pets.add(Pet().fromMap(docs[i].data() as Map<String, dynamic>));
    }
    return pets;
  }

  Future<Pet> openPetDetails(String petId, String petKind) async {
    DocumentReference petRef =
        await OtherFunctions.getReferenceById(petId, petKind);
    DocumentSnapshot petSnapshot = await petRef.get();
    Pet petData = Pet().fromMap(petSnapshot.data() as Map<String, dynamic>);
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
    petReference
        .set({PetEnum.views.name: ++actualViews}, SetOptions(merge: true));
  }

  void navigateToAuth() {}

  void handleChatButtonPressed() {
    CommonChatFunctions.openChat(
      firstUser: tiutiuUserController.tiutiuUser,
      secondUser: pet.owner!,
    );
  }

  void showInterest({
    required DocumentReference petReference,
    required int actualInteresteds,
  }) {
    petReference.set({
      PetEnum.interesteds.name: ++actualInteresteds,
    }, SetOptions(merge: true));
  }
}
