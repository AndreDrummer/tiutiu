import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/extensions/enum_tostring.dart';

enum TiutiuUserEnum {
  notificationToken,
  betterContact,
  displayName,
  phoneNumber,
  createdAt,
  photoBACK,
  photoURL,
  password,
  landline,
  email,
  uid,
}

class TiutiuUser {
  TiutiuUser({
    this.notificationToken,
    this.betterContact,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
    this.photoBACK,
    this.photoURL,
    this.password,
    this.landline,
    this.email,
    this.uid,
  });

  static TiutiuUser fromSnapshot(DocumentSnapshot snapshot) {
    return TiutiuUser(
      notificationToken: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.notificationToken.tostring()],
      betterContact: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.betterContact.tostring()],
      phoneNumber: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.displayName.tostring()],
      createdAt: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.photoBACK.tostring()],
      photoURL: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.photoURL.tostring()],
      password: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.password.tostring()],
      landline: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.landline.tostring()],
      email: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.email.tostring()],
      uid: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.uid.tostring()],
    );
  }

  static TiutiuUser fromMap(Map<String, dynamic> map) {
    return TiutiuUser(
      notificationToken: map[TiutiuUserEnum.notificationToken.tostring()],
      betterContact: map[TiutiuUserEnum.betterContact.tostring()],
      phoneNumber: map[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: map[TiutiuUserEnum.displayName.tostring()],
      createdAt: map[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: map[TiutiuUserEnum.photoBACK.tostring()],
      photoURL: map[TiutiuUserEnum.photoURL.tostring()],
      password: map[TiutiuUserEnum.password.tostring()],
      landline: map[TiutiuUserEnum.landline.tostring()],
      email: map[TiutiuUserEnum.email.tostring()],
      uid: map[TiutiuUserEnum.uid.tostring()],
    );
  }

  String? notificationToken;
  String? phoneNumber;
  String? displayName;
  int? betterContact;
  String? createdAt;
  String? photoBACK;
  String? photoURL;
  String? landline;
  String? password;
  String? email;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      TiutiuUserEnum.notificationToken.tostring(): notificationToken,
      TiutiuUserEnum.betterContact.tostring(): betterContact,
      TiutiuUserEnum.phoneNumber.tostring(): phoneNumber,
      TiutiuUserEnum.displayName.tostring(): displayName,
      TiutiuUserEnum.createdAt.tostring(): createdAt,
      TiutiuUserEnum.photoBACK.tostring(): photoBACK,
      TiutiuUserEnum.photoURL.tostring(): photoURL,
      TiutiuUserEnum.password.tostring(): password,
      TiutiuUserEnum.landline.tostring(): landline,
      TiutiuUserEnum.email.tostring(): email,
      TiutiuUserEnum.uid.tostring(): uid,
    };
  }
}
