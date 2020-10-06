import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiutiu/providers/auth2.dart';

import '../Model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getPet(String userId, String kind) async {
    return await firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc('posted')
        .collection(kind)
        .get();
  }

  Future<Pet> getPetByReference(DocumentReference petRef) async {
    var pet = await petRef.get();

    return Pet.fromSnapshot(pet);
  }

  Future<List<Pet>> getAllPetsByKind(String userId, {String kind}) async {
    List<Pet> myPets = [];

        print(kind);
    var postedPets = firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc('posted');
    if (kind != null) {
      if (kind == 'Donate') {
        var donates = await postedPets.collection(kind).get();
        for (int i = 0; i < donates.docs.length; i++) {
          myPets.add(Pet.fromSnapshot(donates.docs[i]));
        }
      } else {
        var disappeared = await postedPets.collection('Disappeared').get();
        for (int i = 0; i < disappeared.docs.length; i++) {
          myPets.add(Pet.fromSnapshot(disappeared.docs[i]));
        }
      }
    } else {    
      var donates = await postedPets.collection('Donate').get();
      var disappeared = await postedPets.collection('Disappeared').get();

      for (int i = 0; i < donates.docs.length; i++) {
        myPets.add(Pet.fromSnapshot(donates.docs[i]));
      }
      for (int i = 0; i < disappeared.docs.length; i++) {
        myPets.add(Pet.fromSnapshot(disappeared.docs[i]));
      }
    }

    return myPets;
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

    List lista = [];

    if (petRef.data()['${isAdopt ? 'adoptInteresteds' : 'infoInteresteds'}'] !=
        null) {
      lista =
          petRef.data()['${isAdopt ? 'adoptInteresteds' : 'infoInteresteds'}'];
    }

    await petReference.set(
      {
        '${isAdopt ? 'adoptInteresteds' : 'infoInteresteds'}': [
          ...lista,
          {
            'userReference': userReference,
            'userLat': userLocation.latitude,
            'userLog': userLocation.longitude,
            'position': userPosition,
            'interestedAt': interestedAt
          }
        ]
      },
      SetOptions(merge: true),
    );
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
