abstract class AuthProviders {
  Future<bool> loginWithGoogle({bool autologin = false});

  Future<void> signInWithFacebook({String? token});

  Future<void> passwordReset(String email);

  Future<void> loginWithApple();

  Future<void> signOut();

  Future<void> createUserWithEmailAndPassword({
    required String password,
    required String email,
  });

  Future<void> signInWithEmailAndPassword({
    required String password,
    required String email,
  });
}
