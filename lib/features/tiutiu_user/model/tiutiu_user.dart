import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';

enum TiutiuUserEnum {
  notificationToken,
  showNumberInAd,
  displayName,
  phoneNumber,
  createdAt,
  photoBACK,
  password,
  avatar,
  email,
  uid,
}

class TiutiuUser {
  TiutiuUser({
    this.showNumberInAd = false,
    this.notificationToken,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
    this.photoBACK,
    this.password,
    this.avatar,
    this.email,
    this.uid,
  });

  static TiutiuUser fromSnapshot(DocumentSnapshot snapshot) {
    return TiutiuUser(
      notificationToken: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.notificationToken.tostring()],
      phoneNumber: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.displayName.tostring()],
      createdAt: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.photoBACK.tostring()],
      avatar: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.avatar.tostring()],
      showNumberInAd: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.showNumberInAd.tostring()],
      email: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.email.tostring()],
      uid: (snapshot.data()
          as Map<String, dynamic>)[TiutiuUserEnum.uid.tostring()],
    );
  }

  static TiutiuUser fromMap(Map<String, dynamic> map) {
    return TiutiuUser(
      notificationToken: map[TiutiuUserEnum.notificationToken.tostring()],
      showNumberInAd: map[TiutiuUserEnum.showNumberInAd.tostring()],
      phoneNumber: map[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: map[TiutiuUserEnum.displayName.tostring()],
      createdAt: map[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: map[TiutiuUserEnum.photoBACK.tostring()],
      password: map[TiutiuUserEnum.password.tostring()],
      avatar: map[TiutiuUserEnum.avatar.tostring()],
      email: map[TiutiuUserEnum.email.tostring()],
      uid: map[TiutiuUserEnum.uid.tostring()],
    );
  }

  static TiutiuUser fromMapMigration(Map<String, dynamic> map) {
    return TiutiuUser(
      notificationToken: map[TiutiuUserEnum.notificationToken.tostring()],
      phoneNumber: map[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: map[TiutiuUserEnum.displayName.tostring()],
      createdAt: map[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: map[TiutiuUserEnum.photoBACK.tostring()],
      email: map[TiutiuUserEnum.email.tostring()],
      uid: map[TiutiuUserEnum.uid.tostring()],
      avatar: map['photoURL'],
      showNumberInAd: false,
    );
  }

  String? notificationToken;
  bool showNumberInAd;
  String? phoneNumber;
  String? displayName;
  String? createdAt;
  String? photoBACK;
  String? password;
  String? avatar;
  String? email;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      TiutiuUserEnum.notificationToken.tostring(): notificationToken,
      TiutiuUserEnum.showNumberInAd.tostring(): showNumberInAd,
      TiutiuUserEnum.phoneNumber.tostring(): phoneNumber,
      TiutiuUserEnum.displayName.tostring(): displayName,
      TiutiuUserEnum.createdAt.tostring(): createdAt,
      TiutiuUserEnum.photoBACK.tostring(): photoBACK,
      TiutiuUserEnum.avatar.tostring(): avatar,
      TiutiuUserEnum.email.tostring(): email,
      TiutiuUserEnum.uid.tostring(): uid,
    };
  }
}
