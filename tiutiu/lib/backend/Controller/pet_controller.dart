import '../Model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetController {
  Firestore firestore = Firestore.instance;

  getPet(String id) async {
    Pet pet;
    await firestore.collection('Users').document(pet.owner).collection('Pets').document(id).snapshots().first.then(
      (value) {
        pet = Pet.fromSnapshot(value);
        // pet = Pet(
        //   id: value.data['id'],
        //   name: value.data['name'],
        //   age: value.data['age'],
        //   breed: value.data['breed'],
        //   details: value.data['details'],
        //   size: value.data['size'],
        //   owner: value.data['owner'],
        //   latitude: value.data['latitude'],
        //   longitude: value.data['longitude'],
        //   address: value.data['address'],
        // );
      },
    );

    return pet.toMap();
  }

  Future<List<Pet>> getAllPets(String userId) async {
    List<Pet> pets = [];
    await firestore.collection('Users').document(userId).collection('Pets').getDocuments().then(
          (value) => {
            if (value.documents.isNotEmpty)
              {
                value.documents.forEach(
                  (element) {
                    pets.add(Pet(                      
                      name: element.data['name'],
                      age: element.data['age'],
                      breed: element.data['breed'],
                      details: element.data['details'],
                      size: element.data['size'],
                      owner: element.data['owner'],
                      latitude: element.data['latitude'],
                      longitude: element.data['longitude'],
                      address: element.data['address'],
                    ));
                  },
                )
              }
          },
        );
    return pets;
  }

  Future<void> insertPet(Pet pet, String petKind) async {
    print(pet.toMap());
    await Firestore.instance
        .collection('Users').document(pet.owner).collection('Pets')
        .document('pets')
        .collection(petKind)
        .document()
        .setData(pet.toMap())
        .then(
      (value) {
        print('Inserção realizada com sucesso!');
      },
    );
  }

  Future<void> updatePet(Pet pet, String id) async {
    await Firestore.instance
        .collection('Users').document(pet.owner).collection('Pets')
        .document(id) // pet.id
        .updateData(pet.toMap())
        .then(
      (value) {
        print('Atualização realizada com sucesso!');
      },
    );
  }

  Future<void> deletePet(String userId, String petId) async {
    await firestore.collection('Users').document(userId).collection('Pets').document(petId).delete();
  }
}
