import 'package:tiutiu/features/auth/models/email_password_auth.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/data/store_login.dart';
import 'package:get/get.dart';

enum AuthEnum {
  password,
  token,
  email,
}

class AuthController extends GetxController {
  AuthController({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;

  final Rx<EmailAndPasswordAuth> _emailAndPasswordAuth =
      EmailAndPasswordAuth().obs;
  final RxBool _isCreatingNewAccount = false.obs;
  final RxBool _isShowingPassword = false.obs;

  EmailAndPasswordAuth get emailAndPasswordAuth => _emailAndPasswordAuth.value;
  bool get isCreatingNewAccount => _isCreatingNewAccount.value;
  bool get isShowingPassword => _isShowingPassword.value;
  bool get userExists => _authService.userExists;

  void clearEmailAndPassword() {
    _emailAndPasswordAuth(EmailAndPasswordAuth());
  }

  void updateEmailAndPasswordAuth(
      EmailAndPasswordAuthEnum property, dynamic data) {
    final map = emailAndPasswordAuth.toMap();
    map[property.tostring()] = data;

    _emailAndPasswordAuth(EmailAndPasswordAuth.fromMap(map));
  }

  void set isCreatingNewAccount(bool value) => _isCreatingNewAccount(value);
  void set isShowingPassword(bool value) => _isShowingPassword(value);

  Future<void> createUserWithEmailAndPassword() async {
    final success = await _authService.createUserWithEmailAndPassword(
      password: emailAndPasswordAuth.password!,
      email: emailAndPasswordAuth.email!,
    );

    if (success) {
      Store.saveMap(
        LocalStorageKey.authData,
        {
          AuthEnum.password.tostring(): emailAndPasswordAuth.password!,
          AuthEnum.email.tostring(): emailAndPasswordAuth.email!,
        },
      );
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    final success = await _authService.signInWithEmailAndPassword(
      password: emailAndPasswordAuth.password!,
      email: emailAndPasswordAuth.email!,
    );

    if (success) {
      Store.saveMap(
        LocalStorageKey.authData,
        {
          AuthEnum.password.tostring(): emailAndPasswordAuth.password!,
          AuthEnum.email.tostring(): emailAndPasswordAuth.email!,
        },
      );
    }
  }

  void signOut() async {
    _authService.signOut();
    await Store.remove('userLoggedWithEmailPassword');
    await Store.remove('userLoggedWithFacebook');
    print('Deslogado!');
  }

  Future<void> alreadyRegistered() async {
    final CollectionReference usersEntrepreneur =
        FirebaseFirestore.instance.collection(FirebaseEnvPath.users);
    String id = 'firebaseUser!.uid';
    DocumentSnapshot doc = await usersEntrepreneur.doc(id).get();

    if (doc.data() != null) {
      if ((doc.data() as Map<String, dynamic>)['uid'].toString() == id) {
        // changeRegistered(true);
      }
      return Future.value();
    }

    // changeRegistered(false);
    return Future.value();
  }

  Future<void> passwordReset(String email) async {
    await _authService.passwordReset(email);
  }

  Future<void> tryAutoLoginIn() async {
    if (_authService.userExists) {}

    var userLoggedWithEmailPassword =
        await Store.getMap('userLoggedWithEmailPassword');
    var userLoggedWithFacebook = await Store.getMap('userLoggedWithFacebook');

    if (userLoggedWithEmailPassword != null) {
      print('Login com email e senha');
      final email = userLoggedWithEmailPassword[AuthEnum.email.tostring()];
      final password =
          userLoggedWithEmailPassword[AuthEnum.password.tostring()];
      updateEmailAndPasswordAuth(EmailAndPasswordAuthEnum.password, password);
      updateEmailAndPasswordAuth(EmailAndPasswordAuthEnum.email, email);
      await signInWithEmailAndPassword();
    } else if (userLoggedWithFacebook != null) {
      print('Login com facebook');
      final facebookToken = userLoggedWithFacebook[AuthEnum.token.tostring()];
      await _authService.signInWithFacebook(token: facebookToken);
    } else {
      print('Login com google');
      await _authService.loginWithGoogle(autologin: true);

      return Future.value();
    }

    return Future.value();
  }

  final _startScreenImages = [
    StartScreenAssets.whiteCat,
    StartScreenAssets.hamster,
    StartScreenAssets.pinscher,
    StartScreenAssets.oldMel,
    StartScreenAssets.munkun,
    StartScreenAssets.liu,
    StartScreenAssets.husky,
    StartScreenAssets.hairy,
  ];

  List<String> get startScreenImages => _startScreenImages;
}
