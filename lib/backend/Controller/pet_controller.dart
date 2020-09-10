import 'package:tiutiu/providers/auth2.dart';

import '../Model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, Object>> getPet(String id) async {
    Pet pet;
    await firestore
        .collection('Users')
        .doc(id)
        .collection('Pets')
        .doc(id)
        .snapshots()
        .first
        .then(
      (value) {
        pet = Pet.fromSnapshot(value);
      },
    );

    return pet.toMap();
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
