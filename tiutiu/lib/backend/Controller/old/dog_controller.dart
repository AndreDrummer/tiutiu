// import 'dart:io';
// import '../Database/database.dart';
// import '../Model/dog_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity/connectivity.dart';

// class DogController {
//   DataBaseHandler db = DataBaseHandler.instance;
//   Firestore firestore = Firestore.instance;

//   Future getDog(String id) async {
//     List<Map<String, dynamic>> map = await db.getById('Dog', id);

//     if (map.isNotEmpty) {
//       Dog dog = Dog(
//         id: map[0]['id'],
//         name: map[0]['name'],
//         age: map[0]['age'],
//         breed: map[0]['breed'],
//         details: map[0]['details'],
//         size: map[0]['size'],
//         owner: map[0]['owner'],
//       );
//       return dog;
//     }

//     return [];
//   }

//   getAllDogs() async {
//     List<Map<String, dynamic>> dogList = await db.getAll('Dog');
//     List dogsFromLocal = [];
//     List dogsFromFirebase = [];

//     dogsFromLocal.add(
//       List.generate(
//         dogList.length,
//         (i) {
//           return Dog(
//             id: dogList[i]['id'],
//             name: dogList[i]['name'],
//             age: dogList[i]['age'],
//             breed: dogList[i]['breed'],
//             details: dogList[i]['details'],
//             owner: dogList[i]['owner'].toString(),
//             size: dogList[i]['size'],
//           );
//         },
//       ),
//     );
//     await firestore.collection('Dog').getDocuments().then((value) {        
//       value.documents.forEach((element) {
//         // print(element.data);
//         dogsFromFirebase.add(element.data);
//       });
//     });
//     return [dogsFromLocal, dogsFromFirebase];
//   }

//   Future<void> insertDog(Dog dog) async {
//     await db.insert('Dog', dog).then(
//       (value) async {
//         var connectivityResult = await (Connectivity().checkConnectivity());
//         if (connectivityResult == ConnectivityResult.mobile ||
//             connectivityResult == ConnectivityResult.wifi) {
//           await Firestore.instance
//               .collection('Dog')
//               .document()
//               .setData(dog.toMap())
//               .then(
//             (value) {
//               print('Inserção realizada com sucesso!');
//             },
//           );
//         } else {
//           print(
//               "Seus dados foram salvos localmente, pois você não está conectado com a internet!");
//         }
//       },
//     );
//   }

//   Future<void> updateDog(Dog dog) async {
//     await db.update('Dog', dog);
//   }

//   Future<void> deleteDog(String id) async {
//     await db.delete('Dog', id);
//   }
// }
