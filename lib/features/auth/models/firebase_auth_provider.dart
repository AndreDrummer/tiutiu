import 'package:tiutiu/features/auth/interface/auth_providers.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tiutiu/core/Exceptions/tiutiu_exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

final String _iosClientId =
    '791022711249-jva0r9f0eddfo4skv18c0i1e26clq7pd.apps.googleusercontent.com';

class FirebaseAuthProvider implements AuthProviders {
  FirebaseAuthProvider._();

  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: _iosClientId);
  static FirebaseAuthProvider instance = FirebaseAuthProvider._();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get firebaseAuthUser => _firebaseAuth.currentUser;

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

      // await _sendEmailVerification(_firebaseAuth.currentUser);
    } on FirebaseAuthException catch (error) {
      throw TiuTiuAuthException(error.code);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        password: password,
        email: email,
      );
    } on FirebaseAuthException catch (error) {
      print(error);
      throw TiuTiuAuthException(error.code);
    }
  }

  Future<void> _sendEmailVerification(User? user) async {
    if (user != null && !user.emailVerified) {
      var actionCodeSettings = ActionCodeSettings(
        url: 'https://tiutiu.page.link/verify-email?email=${user.email}',
        androidPackageName: 'com.anjasolutions.tiutiu',
        iOSBundleId: 'com.anjasolutions.tiutiu',
        androidMinimumVersion: '12',
        androidInstallApp: true,
        handleCodeInApp: true,
      );

      await user.sendEmailVerification(actionCodeSettings);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
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
        GoogleSignInAuthentication? googleAuth =
            await _googleUser?.authentication;

        if (googleAuth?.accessToken == null && googleAuth?.idToken == null)
          return false;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        print('Google $credential');

        await _firebaseAuth.signInWithCredential(credential);
      }
    } on Exception catch (error) {
      debugPrint('Erro $error ao realizar login com Google.');
    }

    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> passwordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signInWithFacebook({String? token}) async {
    try {
      final facebookAuthCredential;

      if (token == null) {
        // Trigger the sign-in flow
        final LoginResult result = await FacebookAuth.instance.login();

        // Create a credential from the access token
        facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        if (facebookAuthCredential != null) {}
      } else {
        facebookAuthCredential = FacebookAuthProvider.credential(token);
      }

      await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    } catch (error) {
      throw TiuTiuAuthException('Error validating access token');
    }
  }

  @override
  Future<void> loginWithApple() {
    throw UnimplementedError();
  }
}
