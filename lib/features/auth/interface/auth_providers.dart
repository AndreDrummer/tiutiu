abstract class AuthProviders {
  Future<bool> loginWithGoogle({bool autologin = false});

  Future<void> loginWithFacebook({String? token});

  Future<void> passwordReset(String email);

  Future<void> loginWithApple();

  Future<void> logOut();

  Future<void> createUserWithEmailAndPassword({
    required String password,
    required String email,
  });

  Future<void> loginWithEmailAndPassword({
    required String password,
    required String email,
  });
}
