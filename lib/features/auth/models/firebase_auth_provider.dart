import 'dart:io';

import 'package:tiutiu/features/auth/interface/auth_providers.dart';
import 'package:tiutiu/features/auth/service/whatsapp_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tiutiu/core/Exceptions/tiutiu_exceptions.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthProvider implements AuthProviders {
  FirebaseAuthProvider._();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? '791022711249-e7i7f4re6hrg5hamqcqdebrsjmeqs2sa.apps.googleusercontent.com' : null,
  );

  static FirebaseAuthProvider instance = FirebaseAuthProvider._();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get firebaseAuthUser => _firebaseAuth.currentUser;
  final FacebookAuth _facebookSignIn = FacebookAuth.i;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future sendWhatsAppCode(String countryCode, String phoneNumber, String code) async {
    final whatsSystemService = WhatsAppService(code: code, phoneNumber: phoneNumber, countryCode: countryCode);

    try {
      await whatsSystemService.sendCodeVerification();
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Error sending WhatsApp Message: $exception',
        exception: exception,
      );
      rethrow;
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        password: password,
        email: email,
      );

      await _sendEmailVerification(_firebaseAuth.currentUser);
    } on FirebaseAuthException catch (exception) {
      throw TiuTiuAuthException(exception.code);
    }
  }

  @override
  Future<void> loginWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        password: password,
        email: email,
      );
    } on FirebaseAuthException catch (error) {
      throw TiuTiuAuthException(error.code);
    }
  }

  Future<void> _sendEmailVerification(User? user) async {
    user?.sendEmailVerification();

    // Para quando a atualização já estiver na loja

    // if (user != null && !user.emailVerified) {
    //   var actionCodeSettings = ActionCodeSettings(
    //     url: 'https://tiutiu.page.link/verify-email?email=${user.email}',
    //     androidPackageName: 'com.anjasolutions.tiutiu',
    //     iOSBundleId: 'com.anjasolutions.tiutiuapp',
    //     androidMinimumVersion: '12',
    //     androidInstallApp: true,
    //     handleCodeInApp: true,
    //   );

    //   await user.sendEmailVerification(actionCodeSettings);
    // }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await _signOutHosters();
  }

  Future<void> _signOutHosters() async {
    final facebookToken = await _facebookSignIn.accessToken;

    if (facebookToken != null) {
      _facebookSignIn.logOut();
    }

    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
  }

  @override
  Future<bool> loginWithGoogle({bool autologin = false}) async {
    try {
      GoogleSignInAccount? _googleUser = _googleSignIn.currentUser;

      if (_googleUser == null) {
        if (autologin) {
          _googleUser ??= await _googleSignIn.signInSilently();
        } else {
          _googleUser ??= await _googleSignIn.signIn();
        }
      }

      if (_firebaseAuth.currentUser == null) {
        GoogleSignInAuthentication? googleAuth = await _googleUser?.authentication;

        if (googleAuth?.accessToken == null && googleAuth?.idToken == null) return false;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
      }
    } on Exception catch (error) {
      if (kDebugMode) debugPrint('TiuTiuApp: Erro ao realizar login com Google: $error');
      throw TiuTiuAuthException('$error');
    }

    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> passwordReset(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (exception) {
      if (kDebugMode) debugPrint('TiuTiuApp: An error ocurred when tryna reset Password: $exception');
      throw TiuTiuAuthException(exception.code);
    }
  }

  @override
  Future<bool> loginWithFacebook({bool firstLogin = true}) async {
    try {
      if (kDebugMode) debugPrint('TiuTiuApp: Fisrt Login? $firstLogin');

      final LoginResult result = await _facebookSignIn.login(loginBehavior: LoginBehavior.webOnly);

      if (kDebugMode) debugPrint('TiuTiuApp: Facebook LoginResult ${result.status}');

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData(
          fields: "name,email,picture.width(200),birthday,friends,gender,link",
        );

        AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);

        if (kDebugMode) debugPrint('TiuTiuApp: Facebook Login Data $userData');

        await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        return false;
      }

      return _firebaseAuth.currentUser != null;
    } on FirebaseException catch (exception) {
      if (kDebugMode) debugPrint('TiuTiuApp: An error ocurred when tryna to login with Facebook: $exception');
      throw TiuTiuAuthException(exception.code);
    }
  }

  @override
  Future<bool> loginWithApple() async {
    try {
      final appleIDcredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');

      final firebaseCredential = oAuthProvider.credential(
        accessToken: appleIDcredential.authorizationCode,
        idToken: appleIDcredential.identityToken,
      );

      if (kDebugMode) debugPrint('TiuTiuApp: Dados Apple\n');
      if (kDebugMode) debugPrint('TiuTiuApp: $appleIDcredential\n');
      if (kDebugMode) debugPrint('TiuTiuApp: ${appleIDcredential.email}\n');
      if (kDebugMode) debugPrint('TiuTiuApp: ${appleIDcredential.familyName}\n');
      if (kDebugMode) debugPrint('TiuTiuApp: ${appleIDcredential.givenName}\n');

      final appleUserName = '${appleIDcredential.givenName} ${appleIDcredential.familyName ?? ''}';

      if (kDebugMode) debugPrint('TiuTiuApp: $appleUserName');

      await _firebaseAuth.signInWithCredential(firebaseCredential);
      if (kDebugMode) debugPrint('TiuTiuApp: Firebase Auth ${_firebaseAuth.currentUser}');

      return _firebaseAuth.currentUser != null;
    } on FirebaseException catch (exception) {
      if (kDebugMode) debugPrint('TiuTiuApp: An error ocurred when tryna to login with Apple: $exception');
      throw TiuTiuAuthException(exception.code);
    }
  }
}
