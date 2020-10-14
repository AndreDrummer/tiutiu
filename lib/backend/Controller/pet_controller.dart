import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/providers/auth2.dart';

import '../Model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getPet(String userId, String kind, {bool avalaible = true}) async {
    if (kind == 'Adopted') {
      return await firestore
          .collection('Users')
          .doc(userId)
          .collection('Pets')
          .doc('adopted')
          .collection('Adopteds')
          .where('donated', isEqualTo: avalaible)
          .get();
    }
    return await firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc('posted')
        .collection(kind)
        .where(kind == 'Donate' ? 'donated' : 'found', isEqualTo: !avalaible)
        .get();
  }

  Future<Pet> getPetByReference(DocumentReference petRef) async {
    var pet = await petRef.get();

    return Pet.fromSnapshot(pet);
  }

  Future<List<Pet>> getAllPetsByKind(String userId,
      {String kind, bool adopted = true}) async {
    List<Pet> myPets = [];

    var postedPets = firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc('posted');

    if (kind != null) {
      if (kind == 'Donate') {
        var donates = await postedPets
            .collection(kind)
            .where('donated', isEqualTo: false)
            .get();
        for (int i = 0; i < donates.docs.length; i++) {
          myPets.add(Pet.fromSnapshot(donates.docs[i]));
        }
      } else if (kind == 'Adopted') {
        var adoptedsRef = await firestore
            .collection('Users')
            .doc(userId)
            .collection('Pets')
            .doc('adopted')
            .collection('Adopteds')
            .where('confirmed', isEqualTo: adopted)
            .get();

        for (int i = 0; i < adoptedsRef.docs.length; i++) {
          DocumentSnapshot adopted =
              await adoptedsRef.docs[i].data()['petRef'].get();
          myPets.add(Pet.fromSnapshot(adopted));
        }
      } else {
        var disappeared = await postedPets
            .collection('Disappeared')
            .where('found', isEqualTo: false)
            .get();
        for (int i = 0; i < disappeared.docs.length; i++) {
          myPets.add(Pet.fromSnapshot(disappeared.docs[i]));
        }
      }
    } else {
      var donates = await postedPets
          .collection('Donate')
          .where('donated', isEqualTo: false)
          .get();
      var disappeared = await postedPets
          .collection('Disappeared')
          .where('found', isEqualTo: false)
          .get();

      for (int i = 0; i < donates.docs.length; i++) {
        myPets.add(Pet.fromSnapshot(donates.docs[i]));
      }
      for (int i = 0; i < disappeared.docs.length; i++) {
        myPets.add(Pet.fromSnapshot(disappeared.docs[i]));
      }
    }

    return myPets;
  }

  Future<List<Pet>> getDonatedPets(String userId) async {
    List<Pet> donates = [];

    var donatedPets = await firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc('posted')
        .collection('Donate')
        .where("donated", isEqualTo: true)
        .get();

    for (int i = 0; i < donatedPets.docs.length; i++) {
      donates.add(Pet.fromSnapshot(donatedPets.docs[i]));
    }

    return donates;
  }

  Future<void> insertPet(Pet pet, String petKind, Authentication auth) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.firebaseUser.uid)
        .collection('Pets')
        .doc('posted')
        .collection(petKind)
        .doc()
        .set(pet.toMap())
        .then(
      (value) {
        print('Inserção realizada com sucesso!');
      },
    );
  }

  Future<void> showInterestOrInfo(
    DocumentReference petReference,
    DocumentReference userReference,
    String interestedAt,
    LatLng userLocation,
    int userPosition, {
    bool isAdopt = false,
  }) async {
    var petRef = await petReference.get();

    if (isAdopt) {
      await petRef.reference.collection('adoptInteresteds').doc().set(
        {
          'userReference': userReference,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition,
          'sinalized': false,
          'gaveup': false,
          'interestedAt': interestedAt,
        },
        SetOptions(merge: true),
      );
    } else {
      await petRef.reference.collection('infoInteresteds').doc().set(
        {
          'userReference': userReference,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition,
          'sinalized': false,
          'gaveup': false,
          'interestedAt': interestedAt,
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> updatePet(
      Pet pet, String userId, String petKind, String petId) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc('posted')
        .collection(petKind)
        .doc(petId) // pet.id
        .update(pet.toMap())
        .then(
      (value) {
        print('Atualização realizada com sucesso!');
      },
    );
  }

  Future<void> deletePet(DocumentReference petRef) async {
    await petRef.delete();
  }
}
