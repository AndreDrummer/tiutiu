import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/providers/auth2.dart';

import '../Model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentReference> getReferenceFromPath(String path, DocumentSnapshot snapshot, String fieldName) async {
    final ref = await firestore.doc(path).get();
    updateToTypeReference(snapshot, fieldName, ref.reference);
    return ref.reference;
  }

  Future<void> updateToTypeReference(DocumentSnapshot snapshot, String fieldName, DocumentReference ref) async {
    await snapshot.reference.set({fieldName: ref}, SetOptions(merge: true));
  }

  Future getPetToCount(DocumentReference userReference, String kind, {bool avalaible = true}) async {
    if (kind == 'Adopted') {
      return await firestore
      .collection('Adopted')
      .where('interestedReference', isEqualTo: userReference)      
      .get();
    }

    return await firestore                
        .collection(kind)
        .where('ownerReference', isEqualTo: userReference)
        .where(kind == 'Donate' ? 'donated' : 'found', isEqualTo: !avalaible)
        .get();
  }

  Future<Pet> getPetByReference(DocumentReference petRef) async {
    var pet = await petRef.get();

    return Pet.fromSnapshot(pet);
  }

  Stream<QuerySnapshot> getPetsByUser(String petKind, String userId) {
    return firestore.collection(petKind)
    .where('ownerId', isEqualTo: userId).snapshots();    
  }

  // Future<List<Pet>> getAllPetsByKind(String userId, {String kind, bool isAdopted = true}) async {
  //   List<Pet> myPets = [];

  //   var postedPets = firestore
  //       .collection('Users')
  //       .doc(userId)
  //       .collection('Pets')
  //       .doc('posted');

  //   if (kind != null) {
  //     if (kind == 'Donate') {
  //       var donatesSnapshots = await firestore
  //           .collection(kind)
  //           .where('donated', isEqualTo: false)
  //           .get();
  //       for (int i = 0; i < donatesSnapshots.docs.length; i++) {
  //         myPets.add(Pet.fromSnapshot(donatesSnapshots.docs[i]));
  //       }
  //     } else if (kind == 'Adopted' && isAdopted) {
  //       var adoptedsSnapshots = await firestore            
  //           .collection('Adopteds')
  //           .where('confirmed', isEqualTo: isAdopted)
  //           .get();

  //       for (int i = 0; i < adoptedsSnapshots.docs.length; i++) {
  //         DocumentSnapshot adopted = await adoptedsSnapshots.docs[i].data()['petRef'].get();
  //         myPets.add(Pet.fromSnapshot(adopted));
  //       }
  //     } else {
  //       var disappearedSnapshots = await postedPets
  //           .collection('Disappeared')
  //           .where('found', isEqualTo: false)
  //           .get();
  //       for (int i = 0; i < disappearedSnapshots.docs.length; i++) {
  //         myPets.add(Pet.fromSnapshot(disappearedSnapshots.docs[i]));
  //       }
  //     }
  //   } else {
  //     var donates = await postedPets
  //         .collection('Donate')
  //         .where('donated', isEqualTo: false)
  //         .get();
  //     var disappeared = await postedPets
  //         .collection('Disappeared')
  //         .where('found', isEqualTo: false)
  //         .get();

  //     for (int i = 0; i < donates.docs.length; i++) {
  //       myPets.add(Pet.fromSnapshot(donates.docs[i]));
  //     }
  //     for (int i = 0; i < disappeared.docs.length; i++) {
  //       myPets.add(Pet.fromSnapshot(disappeared.docs[i]));
  //     }
  //   }

  //   return myPets;
  // }
   

  Future<void> showInterestOrInfo({
    DocumentReference petReference,
    DocumentReference userReference,
    String interestedAt,
    String ownerNotificationToken,
    String interestedNotificationToken,
    String userName,
    String petName,
    LatLng userLocation,
    int userPosition, 
    bool isAdopt = false,
  }) async {
    var petRef = await petReference.get();

    if (isAdopt) {
      await petRef.reference.collection('adoptInteresteds').doc().set(
        {
          'notificationType': 'wannaAdopt',
          'userName': userName,
          'petName': petName,
          'userReference': userReference,
          'petReference': petReference,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition,
          'sinalized': false,
          'gaveup': false,
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
          'userName': userName,
          'petName': petName,
          'userReference': userReference,
          'petReference': petReference,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition,
          'sinalized': false,
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
