import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user_model.dart';

class UserController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User> getUser(String id) async {
    User user;
    await firestore.collection('User').doc(id).snapshots().first.then((value) {
      user = User(
        id: value.data()['id'],
        name: value.data()['name'],
        photoURL: value.data()['photoURL'],                
        email: value.data()['email'],
        password: value.data()['password'],
        phoneNumber: value.data()['phoneNumber'],
        landline: value.data()['landline'],
      );
    });

    return user;
  }

  Future<User> getUserByReference(DocumentReference userReference) async {
    User user = User.fromSnapshot(await userReference.get());

    return user;
  }

  Future<void> favorite(String userID, DocumentReference petReference, bool add) async {
    final favorite = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .collection('Pets')
        .doc('favorites')
        .collection('favorites');

    if (add) {
      favorite.doc().set({'id': petReference});       
    } else {
      var petToDelete;

      await favorite.where("id", isEqualTo: petReference).get().then((value) {
        petToDelete = value.docs.first.id;
      });
      
      favorite.doc(petToDelete).delete();    
    }
  }

  Future<List<User>> getAllUsers() async {
    var users = [];
    await firestore.collection('User').get().then((value) {
      value.docs.forEach((element) {
        users.add(User.fromSnapshot(element).toJson());
      });
    });
    return users;
  }

  Future<void> insertUser(User user) async {
    print('..inserindo');
    await firestore.collection('User').doc().set(user.toMap()).then((value) {
      print('Usuário Inserido!');
    });
  }

  Future<void> updateUser(User user) async {
    await firestore.collection('User').doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await firestore.collection('User').doc(id).delete();
  }
}
