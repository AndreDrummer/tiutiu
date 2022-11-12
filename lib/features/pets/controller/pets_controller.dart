import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:tiutiu/features/chat/common/functions.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PetsController extends GetxController {
  final RxString _loadingText = ''.obs;
  final RxBool _isLoading = false.obs;

  String get loadingText => _loadingText.value;
  bool get isLoading => _isLoading.value;

  void set loadingText(String text) => _loadingText(text);
  void set isLoading(bool value) => _isLoading(value);

  Stream<List<Pet>> teste() {
    return Stream.value(<Pet>[]);
  }

  List<Pet> getPetListFromSnapshots(List<DocumentSnapshot> docs) {
    List<Pet> pets = [];
    for (int i = 0; i < docs.length; i++) {
      pets.add(Pet().fromMap(docs[i].data() as Map<String, dynamic>));
    }
    return pets;
  }

  Future<Pet> openPetDetails(String petId, String petKind) async {
    DocumentReference petRef = await OtherFunctions.getReferenceById(petId, petKind);
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
    petReference.set({PostEnum.views.name: ++actualViews}, SetOptions(merge: true));
  }

  void navigateToAuth() {}

  void handleChatButtonPressed() {
    CommonChatFunctions.openChat(
      senderUser: tiutiuUserController.tiutiuUser,
      receiverUser: Pet().owner!,
    );
  }

  void showInterest({
    required DocumentReference petReference,
    required int actualInteresteds,
  }) {
    petReference.set({
      PostEnum.interesteds.name: ++actualInteresteds,
    }, SetOptions(merge: true));
  }
}
