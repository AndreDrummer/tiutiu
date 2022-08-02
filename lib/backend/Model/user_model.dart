import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.notificationToken,
    required this.betterContact,
    required this.phoneNumber,
    required this.createdAt,
    required this.photoBACK,
    required this.photoURL,
    required this.password,
    required this.landline,
    required this.email,
    required this.name,
    required this.id,
  });

  static User fromSnapshot(DocumentSnapshot snapshot) {
    return User(
      id: (snapshot.data() as Map<String, dynamic>)['uid'],
      betterContact: (snapshot.data() as Map<String, dynamic>)['betterContact'],
      createdAt: (snapshot.data() as Map<String, dynamic>)['createdAt'],
      name: (snapshot.data() as Map<String, dynamic>)['displayName'],
      notificationToken:
          (snapshot.data() as Map<String, dynamic>)['notificationToken'],
      photoURL: (snapshot.data() as Map<String, dynamic>)['photoURL'],
      photoBACK: (snapshot.data() as Map<String, dynamic>)['photoBACK'],
      email: (snapshot.data() as Map<String, dynamic>)['email'],
      password: (snapshot.data() as Map<String, dynamic>)['password'],
      phoneNumber: (snapshot.data() as Map<String, dynamic>)['phoneNumber'],
      landline: (snapshot.data() as Map<String, dynamic>)['landline'],
    );
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      notificationToken: map['notificationToken'],
      betterContact: map['betterContact'],
      phoneNumber: map['phoneNumber'],
      createdAt: map['createdAt'],
      photoBACK: map['photoBACK'],
      password: map['password'],
      landline: map['landline'],
      photoURL: map['photoURL'],
      email: map['email'],
      name: map['name'],
      id: map['id'],
    );
  }

  String notificationToken;
  String phoneNumber;
  int betterContact;
  String createdAt;
  String photoBACK;
  String photoURL;
  String landline;
  String password;
  String email;
  String name;
  String id;

  Map<String, dynamic> toJson() {
    return {
      'notificationToken': notificationToken,
      'betterContact': betterContact,
      'phoneNumber': phoneNumber,
      'photoBACK': photoBACK,
      'createdAt': createdAt,
      'photoURL': photoURL,
      'password': password,
      'landline': landline,
      'email': email,
      'name': name,
      'id': id,
    };
  }

  Map<String, dynamic> toMap() {
    var userMap = <String, dynamic>{};

    userMap['notificationToken'] = notificationToken;
    userMap['betterContact'] = betterContact;
    userMap['phoneNumber'] = phoneNumber;
    userMap['createdAt'] = createdAt;
    userMap['photoBACK'] = photoBACK;
    userMap['password'] = password;
    userMap['landline'] = landline;
    userMap['photoURL'] = photoURL;
    userMap['email'] = email;
    userMap['name'] = name;
    userMap['id'] = id;
    return userMap;
  }
}
