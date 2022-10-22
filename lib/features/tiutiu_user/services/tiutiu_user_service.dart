import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/models/chat_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class TiutiuUserService {
  TiutiuUserService(PetService petService) : _petService = petService;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PetService _petService;

  Future<TiutiuUser> getUserByID(String id) async {
    DocumentSnapshot userSnaphsot =
        await _firestore.collection(newPathToUser).doc(id).get();

    if (userSnaphsot.data() != null)
      return TiutiuUser.fromMap(userSnaphsot.data() as Map<String, dynamic>);
    return TiutiuUser();
  }

  Future<TiutiuUser> getUserByReference(DocumentReference userReference) async {
    TiutiuUser user = TiutiuUser.fromMap(
      (await userReference.get()).data() as Map<String, dynamic>,
    );

    return user;
  }

  Stream<DocumentSnapshot> getUserSnapshots(DocumentReference userReference) {
    return userReference.snapshots();
  }

  Future<void> handleFavorite({
    required DocumentReference userReference,
    required DocumentReference petReference,
    required bool add,
  }) async {
    final favorites = userReference.collection(FirebaseEnvPath.favorites);

    if (add) {
      favorites.doc().set({PetEnum.uid.name: petReference});
    } else {
      var petInRemotionId;

      await favorites
          .where(PetEnum.uid.name, isEqualTo: petReference)
          .get()
          .then((value) {
        petInRemotionId = value.docs.first.id;
      });

      favorites.doc(petInRemotionId).delete();
    }
  }

  void updateUser({required TiutiuUser userData}) {
    _firestore
        .collection(newPathToUser)
        .doc(userData.uid)
        .set(userData.toMap(), SetOptions(merge: true));
  }

  Future<String?> uploadAvatar(String userId, File file) async {
    Reference ref = FirebaseStorage.instance.ref();
    String? avatarURL;

    final avatarRef = ref.child(userProfileStoragePath(userId));

    try {
      var uploadTask = avatarRef.putFile(file);
      await uploadTask.whenComplete(() {
        debugPrint('Success Upload Avatar');
      });

      avatarURL = await avatarRef.getDownloadURL();
    } on FirebaseException catch (error) {
      debugPrint('Ocorreu um erro ao fazer upload do avatar: $error.');
    }

    return avatarURL;
  }

  Future<void> createNotification({
    required Map<String, dynamic> data,
    required String notificationId,
    required String userId,
  }) async {
    await _firestore
        .collection(FirebaseEnvPath.users)
        .doc(userId)
        .collection(FirebaseEnvPath.notifications)
        .doc(notificationId)
        .set(data, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> loadNotifications(String userId) {
    return _firestore
        .collection(FirebaseEnvPath.users)
        .doc(userId)
        .collection(FirebaseEnvPath.notifications)
        .snapshots();
  }

  Stream<QuerySnapshot> loadNotificationsCount(String userId) {
    return _firestore
        .collection(FirebaseEnvPath.users)
        .doc(userId)
        .collection(FirebaseEnvPath.notifications)
        .where(ChatEnum.open.name, isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> loadMyPostedPetsToDonate({required String userId}) {
    return _petService.getPetsByUser(
      petKind: FirebaseEnvPath.donate,
      userId: userId,
    );
  }

  Stream<QuerySnapshot> loadMyPostedPetsDisappeared({required String userId}) {
    return _petService.getPetsByUser(
      petKind: FirebaseEnvPath.disappeared,
      userId: userId,
    );
  }

  Stream<QuerySnapshot> loadMyDonatedPets(DocumentReference userReference) {
    return _firestore
        .collection(FirebaseEnvPath.donate)
        .where('PetEnum.donated', isEqualTo: true)
        .where('PetEnum.ownerReference', isEqualTo: userReference)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserPostsById(String uid) {
    return _firestore
        .collection(pathToPosts)
        .where(PetEnum.ownerId.name, isEqualTo: uid)
        .snapshots();
  }

  Future<void> deleteUserData(DocumentReference userReference) async {
    QuerySnapshot notifications =
        await userReference.collection(FirebaseEnvPath.notifications).get();
    QuerySnapshot petsFavorited =
        await userReference.collection(FirebaseEnvPath.favorites).get();

    QuerySnapshot petsDonated = await _firestore
        .collection(FirebaseEnvPath.donate)
        .where('PetEnum.ownerReference', isEqualTo: userReference)
        .get();

    QuerySnapshot petsDisappeared = await _firestore
        .collection(FirebaseEnvPath.disappeared)
        .where('PetEnum.ownerReference', isEqualTo: userReference)
        .get();

    for (int i = 0; i < petsDonated.docs.length; i++) {
      await petsDonated.docs[i].reference.delete();
      final adoptInterestedsReference = await petsDonated.docs[i].reference
          .collection('adoptInteresteds')
          .get();

      for (QueryDocumentSnapshot doc in adoptInterestedsReference.docs) {
        doc.reference.delete();
      }
    }

    for (int i = 0; i < petsDisappeared.docs.length; i++) {
      await petsDisappeared.docs[i].reference.delete();
      final infoInterestedsReference = await petsDonated.docs[i].reference
          .collection('infoInteresteds')
          .get();

      for (QueryDocumentSnapshot doc in infoInterestedsReference.docs) {
        doc.reference.delete();
      }
    }

    for (int i = 0; i < petsFavorited.docs.length; i++) {
      await petsFavorited.docs[i].reference.delete();
    }

    for (int i = 0; i < notifications.docs.length; i++) {
      await notifications.docs[i].reference.delete();
    }

    await userReference.delete();
  }

  Future<void> deleteUserAccount({
    required DocumentReference userReference,
  }) async {}
}
