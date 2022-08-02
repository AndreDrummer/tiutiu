import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/utils/constantes.dart';

import '../Model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentReference> getReferenceFromPath(
      String path, DocumentSnapshot snapshot, String fieldName) async {
    final ref = await firestore.doc(path).get();
    updateToTypeReference(snapshot, fieldName, ref.reference);
    return ref.reference;
  }

  Future<void> updateToTypeReference(DocumentSnapshot snapshot,
      String fieldName, DocumentReference ref) async {
    await snapshot.reference.set({fieldName: ref}, SetOptions(merge: true));
  }

  Future getPetToCount(DocumentReference userReference, String kind,
      {bool avalaible = true}) async {
    if (kind == Constantes.ADOPTED) {
      return await firestore
          .collection(Constantes.ADOPTED)
          .where('interestedReference', isEqualTo: userReference)
          .get();
    }

    return await firestore
        .collection(kind)
        .where('ownerReference', isEqualTo: userReference)
        .where(kind == Constantes.DONATE ? 'donated' : 'found',
            isEqualTo: !avalaible)
        .get();
  }

  Future<Pet> getPetByReference(DocumentReference petRef) async {
    var pet = await petRef.get();

    return Pet.fromSnapshot(pet);
  }

  Stream<QuerySnapshot> getPetsByUser(String petKind, String userId,
      {bool isAdopted = false}) {
    Query query = firestore
        .collection(petKind)
        .where(isAdopted ? 'interestedID' : 'ownerId', isEqualTo: userId);
    if (petKind == Constantes.DONATE)
      query = query..where('donated', isEqualTo: false);
    if (isAdopted) query = query.where('confirmed', isEqualTo: true);

    return query.snapshots();
  }

  Stream<QuerySnapshot> getAdoptionsToConfirm(String userId) {
    return firestore
        .collection(Constantes.ADOPTED)
        .where('interestedID', isEqualTo: userId)
        .where('confirmed', isEqualTo: false)
        .snapshots();
  }

  Future<void> deleteOldInterest(
      DocumentReference petReference, DocumentReference userReference) async {
    QuerySnapshot adoptInterestedsRef = await petReference
        .collection('adoptInteresteds')
        .where('userReference', isEqualTo: userReference)
        .get();

    List<QueryDocumentSnapshot> docs = adoptInterestedsRef.docs;
    for (int i = 0; i < docs.length; i++) {
      docs[i].reference.delete();
    }
  }

  Future<void> showInterestOrInfo({
    required DocumentReference userReference,
    required DocumentReference petReference,
    String? interestedNotificationToken,
    String? ownerNotificationToken,
    required LatLng userLocation,
    String? interestedName,
    String? interestedID,
    String? interestedAt,
    bool isAdopt = false,
    String? infoDetails,
    int? userPosition,
    String? petAvatar,
    String? petBreed,
    String? ownerID,
    String? petName,
  }) async {
    var petRef = await petReference.get();

    if (isAdopt) {
      await petRef.reference.collection('adoptInteresteds').doc().set(
        {
          'notificationType': 'wannaAdopt',
          'interestedName': interestedName,
          'petName': petName,
          'petAvatar': petAvatar,
          'petBreed': petBreed,
          'userReference': userReference,
          'petReference': petReference,
          'ownerID': ownerID,
          'infoDetails': infoDetails,
          'interestedID': interestedID,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition,
          'sinalized': false,
          'gaveup': false,
          'donated': false,
          'interestedAt': interestedAt,
          'interestedNotificationToken': interestedNotificationToken,
          'ownerNotificationToken': ownerNotificationToken,
        },
        SetOptions(merge: true),
      );
    } else {
      await petRef.reference.collection('infoInteresteds').doc().set(
        {
          'notificationType': 'petInfo',
          'interestedName': interestedName,
          'petName': petName,
          'petAvatar': petAvatar,
          'infoDetails': infoDetails,
          'petBreed': petBreed,
          'userReference': userReference,
          'petReference': petReference,
          'ownerID': ownerID,
          'interestedID': interestedID,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition,
          'sinalized': false,
          'donated': false,
          'gaveup': false,
          'interestedAt': interestedAt,
          'interestedNotificationToken': interestedNotificationToken,
          'ownerNotificationToken': ownerNotificationToken,
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> insertPet(Pet pet, String petKind, Authentication auth) async {
    await FirebaseFirestore.instance.collection(petKind).doc().set(pet.toMap());
  }

  Future<void> updatePet(Pet pet, DocumentReference petReference) async {
    await petReference.update(pet.toMap());
  }

  Future<void> deletePet(DocumentReference petRef) async {
    await petRef.delete();
  }
}
