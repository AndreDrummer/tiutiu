import 'package:tiutiu/core/Exceptions/titiu_exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuth get firebaseAuth => _firebaseAuth;
  GoogleSignIn get googleSignIn => _googleSignIn;

  Future<User?> createUserWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    try {
      late User? user;

      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        password: password,
        email: email,
      );

      user = userCredential.user;

      await _sendEmailVerification(user);

      return user;
    } on FirebaseAuthException catch (error) {
      throw TiuTiuAuthException(error.code);
    }
  }

  Future<User?> signInWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    try {
      late User? user;

      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        password: password,
        email: email,
      );

      user = userCredential.user;

      return user;
    } on FirebaseAuthException catch (error) {
      throw TiuTiuAuthException(error.code);
    }
  }

  Future<void> _sendEmailVerification(User? user) async {
    if (user != null && !user.emailVerified) {
      var actionCodeSettings = ActionCodeSettings(
        url: 'https://tiutiu.page.link/jdF1?email=${user.email}',
        androidPackageName: 'com.anjasolutions.tiutiu',
        iOSBundleId: 'com.anjasolutions.tiutiu',
        dynamicLinkDomain: 'example.page.link',
        androidMinimumVersion: '12',
        androidInstallApp: true,
        handleCodeInApp: true,
      );

      await user.sendEmailVerification(actionCodeSettings);
    }
  }
}
