import 'package:tiutiu/features/auth/models/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider.instance;
  User? get authUser => FirebaseAuthProvider.instance.firebaseAuthUser;

  Future<bool> loginWithGoogle({bool autologin = false}) async {
    return await _firebaseAuthProvider.loginWithGoogle(autologin: autologin);
  }

  Future<bool> loginWithFacebook({bool firstLogin = true}) async {
    return await _firebaseAuthProvider.loginWithFacebook(
      firstLogin: firstLogin,
    );
  }

  Future<void> loginWithApple() async {
    await _firebaseAuthProvider.loginWithApple();
  }

  Future<bool> loginWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    await _firebaseAuthProvider.loginWithEmailAndPassword(
      password: password,
      email: email,
    );

    return authUser != null;
  }

  Future<bool> createUserWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    await _firebaseAuthProvider.createUserWithEmailAndPassword(
      password: password,
      email: email,
    );

    return authUser != null;
  }

  Future<void> passwordReset(String email) async {
    await _firebaseAuthProvider.passwordReset(email);
  }

  Future<void> logOut() async {
    await _firebaseAuthProvider.logOut();
  }

  bool get userExists => authUser != null;
}
