import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/user_model.dart';

class UserController {
  Firestore firestore = Firestore.instance;

  Future<User> getUser(String id) async {
    User user;
    await firestore
        .collection('User')
        .document(id)
        .snapshots()
        .first
        .then((value) {
      user = User(
        id: value.data['id'],
        name: value.data['name'],
        avatar: value.data['avatar'],
        adopted: value.data['adopted: '],
        donated: value.data['donated'],
        email: value.data['email'],
        password: value.data['password'],
        phone: value.data['phone'],
        whatsapp: value.data['whatsapp'],
      );
    });

    return user;
  }

  Future<List<User>> getAllUsers() async {
    var users = [];
    await firestore.collection('User').getDocuments().then((value) {
      value.documents.forEach((element) {
        users.add(User.fromSnapshot(element).toJson());
      });
    });
    return users;
  }

  Future<void> insertUser(User user) async {
    print('..inserindo');
    await firestore
        .collection('User')
        .document()
        .setData(user.toMap())
        .then((value) {
      print('Usuário Inserido!');
    });
  }

  Future<void> updateUser(User user) async {
    await firestore
        .collection('User')
        .document(user.id)
        .updateData(user.toMap());
  }

  Future<void> deleteUser(String id) async {
    await firestore.collection('User').document(id).delete();
  }
}
