import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.id,
    this.name,
    this.notificationToken,
    this.photoURL,
    this.email,
    this.password,
    this.landline,
    this.phoneNumber,
    this.createdAt,
  });

  User.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()['uid'];
    betterContact = snapshot.data()['betterContact'];
    createdAt = snapshot.data()['createdAt'];
    name = snapshot.data()['displayName'];
    notificationToken = snapshot.data()['notificationToken'];
    photoURL = snapshot.data()['photoURL'];
    photoBACK = snapshot.data()['photoBACK'];
    email = snapshot.data()['email'];
    password = snapshot.data()['password'];
    phoneNumber = snapshot.data()['phoneNumber'];
    landline = snapshot.data()['landline'];
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    betterContact = map['betterContact'];
    createdAt = map['createdAt'];
    name = map['name'];
    notificationToken = map['notificationToken'];
    photoURL = map['photoURL'];
    photoBACK = map['photoBACK'];
    email = map['email'];
    password = map['password'];
    phoneNumber = map['phoneNumber'];
    landline = map['landline'];
  }

  String id;
  int betterContact;
  String name;
  String createdAt;
  String photoURL;
  String notificationToken;
  String photoBACK;
  String email;
  String password;
  String landline;
  String phoneNumber;

  Map<String, dynamic> toJson() {
    return {
      'betterContact': betterContact,
      'id': id,
      'name': name,
      'notificationToken': notificationToken,
      'createdAt': createdAt,
      'photoURL': photoURL,
      'photoBACK': photoBACK,
      'email': email,
      'password': password,
      'landline': landline,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, Object> toMap() {
    var userMap = {};
    userMap['betterContact'] = betterContact;
    userMap['id'] = id;
    userMap['name'] = name;
    userMap['notificationToken'] = notificationToken;
    userMap['createdAt'] = createdAt;
    userMap['photoURL'] = photoURL;
    userMap['photoBACK'] = photoBACK;
    userMap['email'] = email;
    userMap['password'] = password;
    userMap['landline'] = landline;
    userMap['phoneNumber'] = phoneNumber;
    return userMap;
  }
}
