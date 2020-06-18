import 'dart:io';
import '../Database/database.dart';
import '../Model/dog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

class DogController {
  DataBaseHandler db = DataBaseHandler.instance;
  Firestore firestore = Firestore.instance;

  getDog(String id) async {
    Dog dog;
    await firestore
        .collection('Dog')
        .document('ABgelTn2w8scy7SFC05L')
        .snapshots()
        .first
        .then(
      (value) {
        dog = Dog(
          id: value.data['id'],
          name: value.data['name'],
          age: value.data['age'],
          breed: value.data['breed'],
          details: value.data['details'],
          size: value.data['size'],
          owner: value.data['owner'],
        );
      },
    );

    return dog;
  }

  getAllDogs() async {
    List<Dog> dogs = [];
    await firestore.collection('Dog').getDocuments().then(
          (value) => {
            if (value.documents.isNotEmpty)
              {
                value.documents.forEach(
                  (element) {
                    dogs.add(Dog(
                      id: element.data['id'],
                      name: element.data['name'],
                      age: element.data['age'],
                      breed: element.data['breed'],
                      details: element.data['details'],
                      size: element.data['size'],
                      owner: element.data['owner'],
                    ));
                  },
                )
              }
          },
        );
    return dogs;
  }

  Future<void> insertDog(Dog dog) async {
    await Firestore.instance
        .collection('Dog')
        .document()
        .setData(dog.toMap())
        .then(
      (value) {
        print('Inserção realizada com sucesso!');
      },
    );
  }

  Future<void> updateDog(Dog dog) async {
    await Firestore.instance
        .collection('Dog')
        .document('ABgelTn2w8scy7SFC05L') // dog.id
        .updateData(dog.toMap())
        .then(
      (value) {
        print('Atualização realizada com sucesso!');
      },
    );
  }

  Future<void> deleteDog(String id) async {
    await firestore.collection('Dog').document('0cXVckgXNLj0v3fdz3Zr').delete();
  }
}
