import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/data/store_login.dart';

enum AuthEnum {
  password,
  token,
  email,
}

class AuthController extends GetxController {
  AuthController({required AuthService authService})
      : _authService = authService;

  final AuthService _authService;

  bool get userExists => _authService.userExists;

  Future<void> createUserWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    final success = await _authService.createUserWithEmailAndPassword(
      password: password,
      email: email,
    );

    if (success) {
      Store.saveMap(
        LocalStorageKey.authData,
        {
          AuthEnum.password.tostring(): password,
          AuthEnum.email.tostring(): email,
        },
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    final success = await _authService.signInWithEmailAndPassword(
      password: password,
      email: email,
    );

    if (success) {
      Store.saveMap(
        LocalStorageKey.authData,
        {
          AuthEnum.password.tostring(): password,
          AuthEnum.email.tostring(): email,
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
      await signInWithEmailAndPassword(
        password: password,
        email: email,
      );
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
