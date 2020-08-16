import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserModel {
  FirebaseUserModel(this.user);

  
  FirebaseUserModel.fromMap(Map<String, dynamic> user) {
    var newUser;
    newUser.providerId = user['providerId'];
    newUser.displayName = user['displayName'];
    newUser.email = user['email'];
    newUser.phoneNumber = user['phoneNumber'];
    newUser.photoUrl = user['photoUrl'];
    newUser.uid = user['uid'];
    // newUser.hashCode = user['hashCode'];
    newUser.isAnonymous = user['isAnonymous'];
    newUser.isEmailVerified = user['isEmailVerified'];
    // // newUser.providerData = user['providerData'];
    // newUser.toString = user['toString'];
    newUser.reauthenticateWithCredential = user['reauthenticateWithCredential'];
    newUser.delete = user['delete'];
    newUser.getIdToken = user['getIdToken'];
    newUser.linkWithCredential = user['linkWithCredential'];
    newUser.metadata = user['metadata'];
    // newUser.noSuchMethod = user['noSuchMethod'];
    newUser.reload = user['reload'];
    newUser.sendEmailVerification = user['sendEmailVerification'];
    // newUser.runtimeType = user['runtimeType'];
    newUser.unlinkFromProvider = user['unlinkFromProvider'];
    newUser.updateEmail = user['updateEmail'];
    newUser.updatePassword = user['updatePassword'];
    newUser.updatePhoneNumberCredential = user['updatePhoneNumberCredential'];
    newUser.updateProfile = user['updateProfile'];    
  }

  FirebaseUser user;

  String providerId;
  String displayName;
  String email;
  String phoneNumber;
  String photoUrl;
  String uid;
  // @override
  // int hashCode;
  bool isAnonymous;
  bool isEmailVerified;
  // List<UserInfo> providerData;
  // @override
  // String Function() toString;
  Future<AuthResult> Function(AuthCredential) reauthenticateWithCredential;
  Future<void> Function() delete;
  Future<IdTokenResult> Function({bool refresh}) getIdToken;
  Future<AuthResult> Function(AuthCredential credential) linkWithCredential;
  FirebaseUserMetadata metadata;
  // @override
  // Function(Invocation invocation) noSuchMethod;
  Future<void> Function() reload;
  Future<void> Function() sendEmailVerification;
  // @override
  // Type runtimeType;
  Future<void> Function(String) unlinkFromProvider;
  Future<void> Function(String) updateEmail;
  Future<void> Function(String) updatePassword;
  Future<void> Function(AuthCredential) updatePhoneNumberCredential;
  Future<void> Function(UserUpdateInfo userUpdateInfo) updateProfile;

  Map<String, Object> toJson() {
    return {
      'providerId': user.providerId,
      'displayName': user.displayName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoUrl': user.photoUrl,
      'uid': user.uid,
      // 'hashCode': user.hashCode,
      'isAnonymous': user.isAnonymous,
      'isEmailVerified': user.isEmailVerified,
      // // 'providerData': user.providerData,
      // 'toString': user.toString,
      'reauthenticateWithCredential': user.reauthenticateWithCredential,
      'delete': user.delete,
      'getIdToken': user.getIdToken,
      'linkWithCredential': user.linkWithCredential,
      'metadata': user.metadata,
      // 'noSuchMethod': user.noSuchMethod,
      'reload': user.reload,
      'sendEmailVerification': user.sendEmailVerification,
      // 'runtimeType': user.runtimeType,
      'unlinkFromProvider': user.unlinkFromProvider,
      'updateEmail': user.updateEmail,
      'updatePassword': user.updatePassword,
      'updatePhoneNumberCredential': user.updatePhoneNumberCredential,
      'updateProfile': user.updateProfile,
    };
  }
}
