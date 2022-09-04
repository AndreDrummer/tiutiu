import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'package:tiutiu/core/models/filter_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/constants/strings.dart';

class PetService {
  PetService._();

  static PetService instance = PetService._();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> loadPets(
    FilterParams filterParams,
  ) {
    // return FirebaseFirestore.instance
    //     .collection(FirebaseEnvPath.donate)
    //     .where('donated', isEqualTo: false)
    //     .snapshots();

    final filterType =
        filterParams.type == FilterStrings.all ? null : filterParams.type;

    return FirebaseFirestore.instance
        .collection(newPathToAds)
        .where(FilterParamsEnum.type.tostring(), isEqualTo: filterType)
        .snapshots();
  }

  Future<DocumentReference> getReferenceFromPath(
      String path, DocumentSnapshot snapshot, String fieldName) async {
    final ref = await _firestore.doc(path).get();
    updateToTypeReference(snapshot, fieldName, ref.reference);
    return ref.reference;
  }

  Future<void> updateToTypeReference(DocumentSnapshot snapshot,
      String fieldName, DocumentReference ref) async {
    await snapshot.reference.set({fieldName: ref}, SetOptions(merge: true));
  }

  Future getPetToCount(DocumentReference userReference, String kind,
      {bool avalaible = true}) async {
    if (kind == FirebaseEnvPath.adopted) {
      return await _firestore
          .collection(FirebaseEnvPath.adopted)
          .where('interestedReference', isEqualTo: userReference)
          .get();
    }

    return await _firestore
        .collection(kind)
        .where('ownerReference', isEqualTo: userReference)
        .where(kind == FirebaseEnvPath.donate ? 'donated' : 'found',
            isEqualTo: !avalaible)
        .get();
  }

  Future<Pet> getPetByReference(DocumentReference petRef) async {
    var pet = await petRef.get();

    return Pet.fromMap(pet.data() as Map<String, dynamic>);
  }

  Stream<QuerySnapshot> getPetsByUser(String petKind, String userId,
      {bool isAdopted = false}) {
    Query query = _firestore
        .collection(petKind)
        .where(isAdopted ? 'interestedID' : 'ownerId', isEqualTo: userId);
    if (petKind == FirebaseEnvPath.donate)
      query = query..where('donated', isEqualTo: false);
    if (isAdopted) query = query.where('confirmed', isEqualTo: true);

    return query.snapshots();
  }

  Stream<QuerySnapshot> getAdoptionsToConfirm(String userId) {
    return _firestore
        .collection(FirebaseEnvPath.adopted)
        .where('interestedID', isEqualTo: userId)
        .where('confirmed', isEqualTo: false)
        .snapshots();
  }

  Future<void> deleteOldInterest(DocumentReference petReference,
      {DocumentReference? userReference}) async {
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
    DocumentReference? userReference,
    DocumentReference? petReference,
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
    var petRef = await petReference?.get();

    if (isAdopt) {
      await petRef?.reference.collection('adoptInteresteds').doc().set(
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
      await petRef?.reference.collection('infoInteresteds').doc().set(
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

  Future<void> insertPet(Pet pet, String petKind) async {
    await FirebaseFirestore.instance.collection(petKind).doc().set(pet.toMap());
  }

  Future<void> updatePet(Pet pet, DocumentReference petReference) async {
    await petReference.update(pet.toMap());
  }

  Future<void> deletePet(DocumentReference petRef) async {
    await petRef.delete();
  }
}
