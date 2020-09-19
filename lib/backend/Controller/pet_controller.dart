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

  Future<List<Pet>> getAllPets(String userId) async {
    var pets = [];
    await firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .get()
        .then(
          (value) => {
            if (value.docs.isNotEmpty)
              {
                value.docs.forEach(
                  (element) {
                    pets.add(Pet.fromSnapshot(element).toJson());
                  },
                )
              }
          },
        );
    return pets;
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
    LatLng userLocation,
    int userPosition, {
    bool isAdopt = false,
  }) async {

    var petRef = await petReference.get();

    List lista = [];

    if(petRef.data()['${isAdopt ? 'adoptInteresteds' : 'infoInteresteds'}'] != null) {
      lista = petRef.data()['${isAdopt ? 'adoptInteresteds' : 'infoInteresteds'}'];
    }



    await petReference.set(
      {
          '${isAdopt ? 'adoptInteresteds' : 'infoInteresteds'}': [...lista, {
          'userReference': userReference,
          'userLat': userLocation.latitude,
          'userLog': userLocation.longitude,
          'position': userPosition
        }]
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updatePet(Pet pet, String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .collection('Pets')
        .doc(id) // pet.id
        .update(pet.toMap())
        .then(
      (value) {
        print('Atualização realizada com sucesso!');
      },
    );
  }

  Future<void> deletePet(String userId, String petId) async {
    await firestore
        .collection('Users')
        .doc(userId)
        .collection('Pets')
        .doc(petId)
        .delete();
  }
}
