import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiutiu/data/store_login.dart';
import 'package:tiutiu/Exceptions/titiu_exceptions.dart';

class Authentication extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Future<void> loginWithGoogle({bool autologin = false}) async {
    // ignore: omit_local_variable_types
    GoogleSignInAccount googleUser = _googleSignIn.currentUser;

    /* ??= --> Verifica se é nulo e atribui caso verdade */
    if (autologin) {      
      googleUser ??= await _googleSignIn.signInSilently();
    } else {      
      googleUser ??= await _googleSignIn.signIn();
    }

    if (googleUser == null) {      
      return Future.value();
    }

    firebaseUser = await _auth.currentUser();
    // ignore: omit_local_variable_types
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    if (firebaseUser == null) {

      // ignore: omit_local_variable_types
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );     
      firebaseUser = (await _auth.signInWithCredential(credential)).user;
    }

    notifyListeners(); 
    return Future.value();
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // ignore: omit_local_variable_types
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;

      if (firebaseUser != null) {
        Store.saveMap('userLogged', {
          'email': email,
          'password': password,
        });
      }
    } catch (error) {
      if (Platform.isAndroid) {
        throw TiuTiuAuthException(error.code);
      }
    }

    notifyListeners();
    return Future.value();
  }

  Future<void> passwordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    return Future.value();
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // ignore: omit_local_variable_types
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;

      if (firebaseUser != null) {
        Store.saveMap('userLogged', {
          'email': email,
          'password': password,
        });
      }
    } catch (error) {
      if (Platform.isAndroid) {
        throw TiuTiuAuthException(error.code);
      }
    }

    notifyListeners();
    return Future.value();
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await Store.remove('userLogged');
    firebaseUser = null;
    notifyListeners();
    print('Deslogado!');
  }

  Future<void> tryAutoLoginIn() async {
    if (firebaseUser != null) {
      print('firebaseUser não é nulo');
      return Future.value();
    }

    var userData = await Store.getMap('userLogged');

    if (userData != null) {
      print('Login com email e senha');
      final email = userData['email'];
      final password = userData['password'];
      await signInWithEmailAndPassword(email, password);
    } else {
      print('Login com google');
      await loginWithGoogle(autologin: true);

      return Future.value();
    }

    notifyListeners();
    return Future.value();
  }
}
