import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.id,
    this.name,
    this.photoURL,
    this.email,
    this.password,
    this.landline,        
    this.phoneNumber,    
  });
  
  User.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()['uid'];
    betterContact = snapshot.data()['betterContact'];
    name = snapshot.data()['displayName'];
    photoURL = snapshot.data()['photoURL'];        
    photoBACK = snapshot.data()['photoBACK'];        
    email = snapshot.data()['email'];
    password = snapshot.data()['password'];
    phoneNumber = snapshot.data()['phoneNumber'];
    landline = snapshot.data()['landline'];
  }
  
  User.fromMap(Map<String, dynamic> map) {
    id = map['uid'];
    betterContact = map['betterContact'];
    name = map['displayName'];
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
  String photoURL;
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
    userMap['photoURL'] = photoURL;
    userMap['photoBACK'] = photoBACK;
    userMap['email'] = email;
    userMap['password'] = password;
    userMap['landline'] = landline;
    userMap['phoneNumber'] = phoneNumber;        
    return userMap;
  }

}
