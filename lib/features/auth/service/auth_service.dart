import 'package:tiutiu/features/auth/models/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuthProvider _firebaseAuthProvider = FirebaseAuthProvider.instance;
  User? get authUser => FirebaseAuthProvider.instance.firebaseAuthUser;

  Future<bool> loginWithGoogle({bool autologin = false}) async {
    return await _firebaseAuthProvider.loginWithGoogle(autologin: autologin);
  }

  Future<void> signInWithFacebook({String? token}) async {
    await _firebaseAuthProvider.signInWithFacebook(token: token);
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

  Future<bool> signInWithEmailAndPassword({
    required String password,
    required String email,
  }) async {
    await _firebaseAuthProvider.signInWithEmailAndPassword(
      password: password,
      email: email,
    );

    return authUser != null;
  }

  Future<void> passwordReset(String email) async {
    await _firebaseAuthProvider.passwordReset(email);
  }

  Future<void> loginWithApple() async {
    await _firebaseAuthProvider.loginWithApple();
  }

  Future<void> signOut() async {
    await _firebaseAuthProvider.signOut();
  }

  bool get userExists => authUser != null;
}
