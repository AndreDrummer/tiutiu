import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.id,
    this.name,
    this.avatar,
    this.email,
    this.password,
    this.whatsapp,
    this.adopted,
    this.donated,
    this.phone,
    this.disappeared
  });
  
  User.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data['id'];
    name = snapshot.data['name'];
    avatar = snapshot.data['avatar'];
    adopted = snapshot.data['adopted: '];
    donated = snapshot.data['donated'];
    email = snapshot.data['email'];
    password = snapshot.data['password'];
    phone = snapshot.data['phone'];
    whatsapp = snapshot.data['whatsapp'];
  }

  String id;
  String name;
  String avatar;
  String email;
  String password;
  String whatsapp;
  String phone;
  int adopted;
  int donated;
  int disappeared;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'password': password,
      'whatsapp': whatsapp,
      'phone': phone,
      'adopted': adopted,
      'donated': donated,
    };
  }

  Map<String, Object> toMap() {
    var userMap = {};
    userMap['id'] = id;
    userMap['name'] = name;
    userMap['avatar'] = avatar;
    userMap['email'] = email;
    userMap['password'] = password;
    userMap['whatsapp'] = whatsapp;
    userMap['phone'] = phone;
    userMap['adopted'] = adopted;
    userMap['donated'] = donated;

    return userMap;
  }

}
