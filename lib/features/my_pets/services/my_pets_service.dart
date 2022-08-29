import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPetsService {
  Future<List<Pet>> loadMyPetsToDonate(String userId) async {
    final donates = await FirebaseFirestore.instance
        .collection(FirebaseEnvPath.users)
        .doc(userId)
        .collection('Pets')
        .doc('posted')
        .collection(FirebaseEnvPath.donate)
        .get();

    return donates.docs.map((snapshot) => Pet.fromSnapshot(snapshot)).toList();
  }

  Future<List<Pet>> loadMyPetsDisappeareds(String userId) async {
    final disappeared = await FirebaseFirestore.instance
        .collection(FirebaseEnvPath.users)
        .doc(userId)
        .collection('Pets')
        .doc('posted')
        .collection(FirebaseEnvPath.donate)
        .get();

    return disappeared.docs
        .map((snapshot) => Pet.fromSnapshot(snapshot))
        .toList();
  }
}
