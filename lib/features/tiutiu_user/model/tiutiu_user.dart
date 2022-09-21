import 'package:tiutiu/core/extensions/enum_tostring.dart';

enum TiutiuUserEnum {
  allowContactViaWhatsApp,
  notificationToken,
  displayName,
  phoneNumber,
  createdAt,
  lastLogin,
  photoBACK,
  password,
  avatar,
  email,
  uid,
}

class TiutiuUser {
  TiutiuUser({
    this.allowContactViaWhatsApp = false,
    this.notificationToken,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
    this.photoBACK,
    this.lastLogin,
    this.password,
    this.avatar,
    this.email,
    this.uid,
  });

  static TiutiuUser fromMap(Map<String, dynamic> map) {
    return TiutiuUser(
      allowContactViaWhatsApp:
          map[TiutiuUserEnum.allowContactViaWhatsApp.tostring()] ?? false,
      notificationToken: map[TiutiuUserEnum.notificationToken.tostring()],
      avatar: map[TiutiuUserEnum.avatar.tostring()] ?? map['photoURL'],
      phoneNumber: map[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: map[TiutiuUserEnum.displayName.tostring()],
      lastLogin: map[TiutiuUserEnum.lastLogin.tostring()] ??
          map[TiutiuUserEnum.createdAt.tostring()],
      createdAt: map[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: map[TiutiuUserEnum.photoBACK.tostring()],
      password: map[TiutiuUserEnum.password.tostring()],
      email: map[TiutiuUserEnum.email.tostring()],
      uid: map[TiutiuUserEnum.uid.tostring()],
    );
  }

  static TiutiuUser fromMapMigration(Map<String, dynamic> map) {
    return TiutiuUser(
      notificationToken: map[TiutiuUserEnum.notificationToken.tostring()],
      avatar: map[TiutiuUserEnum.avatar.tostring()] ?? map['photoURL'],
      phoneNumber: map[TiutiuUserEnum.phoneNumber.tostring()],
      displayName: map[TiutiuUserEnum.displayName.tostring()],
      createdAt: map[TiutiuUserEnum.createdAt.tostring()],
      photoBACK: map[TiutiuUserEnum.photoBACK.tostring()],
      lastLogin: map[TiutiuUserEnum.lastLogin.tostring()],
      email: map[TiutiuUserEnum.email.tostring()],
      uid: map[TiutiuUserEnum.uid.tostring()],
      allowContactViaWhatsApp: false,
    );
  }

  String? notificationToken;
  bool allowContactViaWhatsApp;
  String? phoneNumber;
  String? displayName;
  String? createdAt;
  String? lastLogin;
  String? photoBACK;
  String? password;
  String? avatar;
  String? email;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      TiutiuUserEnum.notificationToken.tostring(): notificationToken,
      TiutiuUserEnum.allowContactViaWhatsApp.tostring():
          allowContactViaWhatsApp,
      TiutiuUserEnum.phoneNumber.tostring(): phoneNumber,
      TiutiuUserEnum.displayName.tostring(): displayName,
      TiutiuUserEnum.lastLogin.tostring(): lastLogin,
      TiutiuUserEnum.createdAt.tostring(): createdAt,
      TiutiuUserEnum.photoBACK.tostring(): photoBACK,
      TiutiuUserEnum.avatar.tostring(): avatar,
      TiutiuUserEnum.email.tostring(): email,
      TiutiuUserEnum.uid.tostring(): uid,
    };
  }
}
