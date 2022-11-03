enum TiutiuUserEnum {
  allowContactViaWhatsApp,
  notificationToken,
  emailVerified,
  phoneVerified,
  displayName,
  phoneNumber,
  createdAt,
  photoBACK,
  lastLogin,
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
    this.notificationToken,
    this.isAnONG = false,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
    this.photoBACK,
    this.lastLogin,
    this.avatar,
    this.email,
    this.uid,
  });

  static TiutiuUser fromMap(Map<String, dynamic> map) {
    return TiutiuUser(
      allowContactViaWhatsApp: map[TiutiuUserEnum.allowContactViaWhatsApp.name] ?? false,
      lastLogin: map[TiutiuUserEnum.lastLogin.name] ?? map[TiutiuUserEnum.createdAt.name],
      emailVerified: map[TiutiuUserEnum.emailVerified.name] ?? false,
      phoneVerified: map[TiutiuUserEnum.phoneVerified.name] ?? false,
      notificationToken: map[TiutiuUserEnum.notificationToken.name],
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
      notificationToken: map[TiutiuUserEnum.notificationToken.name],
      avatar: map[TiutiuUserEnum.avatar.name] ?? map['photoURL'],
      emailVerified: map[TiutiuUserEnum.emailVerified.name],
      phoneVerified: map[TiutiuUserEnum.phoneVerified.name],
      phoneNumber: map[TiutiuUserEnum.phoneNumber.name],
      displayName: map[TiutiuUserEnum.displayName.name],
      createdAt: map[TiutiuUserEnum.createdAt.name],
      photoBACK: map[TiutiuUserEnum.photoBACK.name],
      lastLogin: map[TiutiuUserEnum.lastLogin.name],
      email: map[TiutiuUserEnum.email.name],
      uid: map[TiutiuUserEnum.uid.name],
      allowContactViaWhatsApp: false,
    );
  }

  bool allowContactViaWhatsApp;
  String? notificationToken;
  bool emailVerified;
  String? phoneNumber;
  String? displayName;
  bool phoneVerified;
  String? createdAt;
  String? lastLogin;
  String? photoBACK;
  dynamic avatar;
  String? email;
  bool isAnONG;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      TiutiuUserEnum.allowContactViaWhatsApp.name: allowContactViaWhatsApp,
      TiutiuUserEnum.notificationToken.name: notificationToken,
      TiutiuUserEnum.emailVerified.name: emailVerified,
      TiutiuUserEnum.emailVerified.name: emailVerified,
      TiutiuUserEnum.phoneVerified.name: phoneVerified,
      TiutiuUserEnum.phoneNumber.name: phoneNumber,
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
