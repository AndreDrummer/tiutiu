import 'package:cloud_firestore/cloud_firestore.dart';

enum TiutiuUserEnum {
  allowContactViaWhatsApp,
  notificationToken,
  reference,
  timesDennounced,
  timesOpenedTheApp,
  emailVerified,
  phoneVerified,
  userDeleted,
  displayName,
  phoneNumber,
  lastLogin,
  photoBACK,
  createdAt,
  isAnONG,
  avatar,
  email,
  uid,
}

class TiutiuUser {
  TiutiuUser({
    this.allowContactViaWhatsApp = false,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.userDeleted = false,
    this.timesOpenedTheApp = 0,
    this.timesDennounced = 0,
    this.notificationToken,
    this.isAnONG = false,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
    this.reference,
    this.photoBACK,
    this.lastLogin,
    this.avatar,
    this.email,
    this.uid,
  });

  static TiutiuUser fromSnapshot(DocumentSnapshot snapshot) {
    return TiutiuUser(
      reference: snapshot.get(TiutiuUserEnum.reference.name) != null
          ? FirebaseFirestore.instance.doc((snapshot.get(TiutiuUserEnum.reference.name)))
          : null,
      lastLogin: snapshot.get(TiutiuUserEnum.lastLogin.name) ?? snapshot.get(TiutiuUserEnum.createdAt.name),
      allowContactViaWhatsApp: snapshot.get(TiutiuUserEnum.allowContactViaWhatsApp.name) ?? false,
      timesOpenedTheApp: snapshot.get(TiutiuUserEnum.timesOpenedTheApp.name) ?? 0,
      avatar: snapshot.get(TiutiuUserEnum.avatar.name) ?? snapshot.get('photoURL'),
      emailVerified: snapshot.get(TiutiuUserEnum.emailVerified.name) ?? false,
      phoneVerified: snapshot.get(TiutiuUserEnum.phoneVerified.name) ?? false,
      timesDennounced: snapshot.get(TiutiuUserEnum.timesDennounced.name) ?? 0,
      notificationToken: snapshot.get(TiutiuUserEnum.notificationToken.name),
      userDeleted: snapshot.get(TiutiuUserEnum.userDeleted.name) ?? false,
      isAnONG: snapshot.get(TiutiuUserEnum.isAnONG.name) ?? false,
      phoneNumber: snapshot.get(TiutiuUserEnum.phoneNumber.name),
      displayName: snapshot.get(TiutiuUserEnum.displayName.name),
      createdAt: snapshot.get(TiutiuUserEnum.createdAt.name),
      photoBACK: snapshot.get(TiutiuUserEnum.photoBACK.name),
      email: snapshot.get(TiutiuUserEnum.email.name),
      uid: snapshot.get(TiutiuUserEnum.uid.name),
    );
  }

  static TiutiuUser fromMap(Map<String, dynamic> map) {
    return TiutiuUser(
      reference: map[TiutiuUserEnum.reference.name] != null ? map[TiutiuUserEnum.reference.name] : null,
      lastLogin: map[TiutiuUserEnum.lastLogin.name] ?? map[TiutiuUserEnum.createdAt.name],
      allowContactViaWhatsApp: map[TiutiuUserEnum.allowContactViaWhatsApp.name] ?? false,
      timesOpenedTheApp: map[TiutiuUserEnum.timesOpenedTheApp.name] ?? 0,
      emailVerified: map[TiutiuUserEnum.emailVerified.name] ?? false,
      phoneVerified: map[TiutiuUserEnum.phoneVerified.name] ?? false,
      timesDennounced: map[TiutiuUserEnum.timesDennounced.name] ?? 0,
      notificationToken: map[TiutiuUserEnum.notificationToken.name],
      userDeleted: map[TiutiuUserEnum.userDeleted.name] ?? false,
      avatar: map[TiutiuUserEnum.avatar.name] ?? map['photoURL'],
      isAnONG: map[TiutiuUserEnum.isAnONG.name] ?? false,
      phoneNumber: map[TiutiuUserEnum.phoneNumber.name],
      displayName: map[TiutiuUserEnum.displayName.name],
      createdAt: map[TiutiuUserEnum.createdAt.name],
      photoBACK: map[TiutiuUserEnum.photoBACK.name],
      email: map[TiutiuUserEnum.email.name],
      uid: map[TiutiuUserEnum.uid.name],
    );
  }

  static TiutiuUser fromMapMigration(Map<String, dynamic> map) {
    return TiutiuUser(
      timesOpenedTheApp: map[TiutiuUserEnum.timesOpenedTheApp.name] ?? 0,
      notificationToken: map[TiutiuUserEnum.notificationToken.name],
      emailVerified: map[TiutiuUserEnum.emailVerified.name] ?? false,
      avatar: map[TiutiuUserEnum.avatar.name] ?? map['photoURL'],
      timesDennounced: map[TiutiuUserEnum.timesDennounced.name] ?? 0,
      phoneVerified: map[TiutiuUserEnum.phoneVerified.name] ?? false,
      userDeleted: map[TiutiuUserEnum.userDeleted.name] ?? false,
      phoneNumber: map[TiutiuUserEnum.phoneNumber.name],
      displayName: map[TiutiuUserEnum.displayName.name],
      reference: map[TiutiuUserEnum.reference.name],
      createdAt: map[TiutiuUserEnum.createdAt.name],
      photoBACK: map[TiutiuUserEnum.photoBACK.name],
      lastLogin: map[TiutiuUserEnum.lastLogin.name],
      email: map[TiutiuUserEnum.email.name],
      uid: map[TiutiuUserEnum.uid.name],
      allowContactViaWhatsApp: false,
    );
  }

  bool allowContactViaWhatsApp;
  DocumentReference? reference;
  String? notificationToken;
  int timesOpenedTheApp;
  String? phoneNumber;
  String? displayName;
  int timesDennounced;
  bool emailVerified;
  bool phoneVerified;
  String? createdAt;
  String? lastLogin;
  String? photoBACK;
  bool userDeleted;
  dynamic avatar;
  String? email;
  bool isAnONG;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      TiutiuUserEnum.reference.name: reference != null ? reference : null,
      TiutiuUserEnum.allowContactViaWhatsApp.name: allowContactViaWhatsApp,
      TiutiuUserEnum.notificationToken.name: notificationToken,
      TiutiuUserEnum.notificationToken.name: notificationToken,
      TiutiuUserEnum.timesOpenedTheApp.name: timesOpenedTheApp,
      TiutiuUserEnum.timesDennounced.name: timesDennounced,
      TiutiuUserEnum.timesDennounced.name: timesDennounced,
      TiutiuUserEnum.emailVerified.name: emailVerified,
      TiutiuUserEnum.phoneVerified.name: phoneVerified,
      TiutiuUserEnum.phoneNumber.name: phoneNumber,
      TiutiuUserEnum.userDeleted.name: userDeleted,
      TiutiuUserEnum.displayName.name: displayName,
      TiutiuUserEnum.lastLogin.name: lastLogin,
      TiutiuUserEnum.photoBACK.name: photoBACK,
      TiutiuUserEnum.createdAt.name: createdAt,
      TiutiuUserEnum.isAnONG.name: isAnONG,
      TiutiuUserEnum.avatar.name: avatar,
      TiutiuUserEnum.email.name: email,
      TiutiuUserEnum.uid.name: uid,
    };
  }
}
