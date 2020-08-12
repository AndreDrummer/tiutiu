import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> handleSignIn() async {
  // ignore: omit_local_variable_types
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

  // ignore: omit_local_variable_types
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // ignore: omit_local_variable_types
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // ignore: omit_local_variable_types
  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print('Signed in ' + user.displayName);
  return Future.value(user);
}

Future<FirebaseUser> createLogin(String email, String password) async {
  final user = (await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  )).user;

  return Future.value(user);
}
