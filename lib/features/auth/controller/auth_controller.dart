import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiutiu/core/Exceptions/titiu_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/data/store_login.dart';
import 'dart:io';

import 'package:tiutiu/features/auth/services/auth_service.dart';

class AuthController extends GetxController {
  AuthController({
    required this.authService,
  });

  late GoogleSignInAccount? _googleUser;
  final AuthService authService;
  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;

  Future<bool> loginWithGoogle({bool autologin = false}) async {
    try {
      _googleUser = authService.googleSignIn.currentUser;

      if (_googleUser == null) {
        if (autologin) {
          _googleUser ??= await authService.googleSignIn.signInSilently();
        } else {
          _googleUser ??= await authService.googleSignIn.signIn();
        }
      }

      if (firebaseUser == null) {
        GoogleSignInAuthentication? googleAuth =
            await _googleUser?.authentication;

        if (googleAuth?.accessToken == null && googleAuth?.idToken == null)
          return false;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        print('Google $credential');
        _firebaseUser =
            (await authService.firebaseAuth.signInWithCredential(credential))
                .user;
      }
    } on Exception catch (error) {
      debugPrint('Erro $error ao realizar login com Google.');
    }

    return firebaseUser != null;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await authService.firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _firebaseUser = result.user;

      if (firebaseUser != null) {
        Store.saveMap('userLoggedWithEmailPassword', {
          'email': email,
          'password': password,
        });
      }
    } catch (error) {
      if (Platform.isAndroid) {
        throw TiuTiuAuthException('$error');
      }
    }

    await alreadyRegistered();
    return Future.value();
  }

  Future<void> passwordReset(String email) async {
    await authService.firebaseAuth.sendPasswordResetEmail(email: email);
    return Future.value();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await authService.firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _firebaseUser = result.user;
      if (firebaseUser != null) {
        Store.saveMap('userLoggedWithEmailPassword', {
          'email': email,
          'password': password,
        });
      }
    } catch (error) {
      if (Platform.isAndroid) {
        print(error);
        throw TiuTiuAuthException('$error');
      }
    }

    await alreadyRegistered();
    return Future.value();
  }

  Future<void> signInWithFacebook({String? token}) async {
    try {
      final facebookAuthCredential;

      if (token == null) {
        // Trigger the sign-in flow
        final LoginResult result = await FacebookAuth.instance.login();

        // Create a credential from the access token
        facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        if (facebookAuthCredential != null) {
          Store.saveMap('userLoggedWithFacebook', {
            'token': result.accessToken!.token,
          });
        }
      } else {
        facebookAuthCredential = FacebookAuthProvider.credential(token);
      }

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      _firebaseUser = userCredential.user;
    } catch (error) {
      throw TiuTiuAuthException('Error validating access token');
    }
    await alreadyRegistered();
    return Future.value();
  }

  void signOut() async {
    await authService.googleSignIn.signOut();
    await authService.firebaseAuth.signOut();
    await Store.remove('userLoggedWithEmailPassword');
    await Store.remove('userLoggedWithFacebook');
    _firebaseUser = null;
    print('Deslogado!');
  }

  Future<void> alreadyRegistered() async {
    final CollectionReference usersEntrepreneur =
        FirebaseFirestore.instance.collection(FirebaseEnvPath.users);
    String id = firebaseUser!.uid;
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

  Future<void> tryAutoLoginIn() async {
    if (authService.firebaseAuth.currentUser != null) {}

    if (firebaseUser != null) {
      print('firebaseUser não é nulo');
      return Future.value();
    }

    var userLoggedWithEmailPassword =
        await Store.getMap('userLoggedWithEmailPassword');
    var userLoggedWithFacebook = await Store.getMap('userLoggedWithFacebook');

    if (userLoggedWithEmailPassword != null) {
      print('Login com email e senha');
      final email = userLoggedWithEmailPassword['email'];
      final password = userLoggedWithEmailPassword['password'];
      await signInWithEmailAndPassword(email, password);
    } else if (userLoggedWithFacebook != null) {
      print('Login com facebook');
      final facebookToken = userLoggedWithFacebook['token'];
      await signInWithFacebook(token: facebookToken);
    } else {
      print('Login com google');
      await loginWithGoogle(autologin: true);

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
