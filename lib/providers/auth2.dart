import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tiutiu/data/store_login.dart';
import 'package:tiutiu/Exceptions/titiu_exceptions.dart';

class Authentication extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _registered = BehaviorSubject<bool>();
  User firebaseUser;

  Stream<bool> get registered => _registered.stream;
  void Function(bool) get changeRegistered => _registered.sink.add;
  bool get getRegistered => _registered.value;

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

    firebaseUser = _auth.currentUser;
    // ignore: omit_local_variable_types
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    if (firebaseUser == null) {
      // ignore: omit_local_variable_types
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      firebaseUser = (await _auth.signInWithCredential(credential)).user;
    }

    notifyListeners();
    await alreadyRegistered();
    return Future.value();
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // ignore: omit_local_variable_types
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;

      if (firebaseUser != null) {
        Store.saveMap('userLoggedWithEmailPassword', {
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
    await alreadyRegistered();
    return Future.value();
  }

  Future<void> passwordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    return Future.value();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      // ignore: omit_local_variable_types
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      firebaseUser = result.user;
      if (firebaseUser != null) {
        Store.saveMap('userLoggedWithEmailPassword', {
          'email': email,
          'password': password,
        });
      }
    } catch (error) {
      if (Platform.isAndroid) {
        print(error.code);
        throw TiuTiuAuthException(error.code);
      }
    }

    notifyListeners();
    await alreadyRegistered();
    return Future.value();
  }

  Future<void> signInWithFacebook({String token}) async {
    FacebookAuthCredential facebookAuthCredential;

    if (token == null) {      
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);

      if (facebookAuthCredential != null) {
        Store.saveMap('userLoggedWithFacebook', {
          'token': result.accessToken.token,
        });
      }
    } else {      
      facebookAuthCredential = FacebookAuthProvider.credential(token);
    }

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    firebaseUser = userCredential.user;
    notifyListeners();
    await alreadyRegistered();
    return Future.value();
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await Store.remove('userLoggedWithEmailPassword');
    await Store.remove('userLoggedWithFacebook');
    firebaseUser = null;
    notifyListeners();
    print('Deslogado!');
  }

  Future<void> alreadyRegistered() async {
    final CollectionReference usersEntrepreneur =
        FirebaseFirestore.instance.collection('Users');
    String id = firebaseUser.uid;
    DocumentSnapshot doc = await usersEntrepreneur.doc(id).get();

    if (doc.data() != null) {
      if (doc.data()['uid'].toString() == id) {
        changeRegistered(true);
      }
      notifyListeners();
      return Future.value();
    }

    changeRegistered(false);
    notifyListeners();
    return Future.value();
  }

  Future<void> tryAutoLoginIn() async {
    if (firebaseUser != null) {
      print('firebaseUser não é nulo');
      return Future.value();
    }

    var userLoggedWithEmailPassword =
        await Store.getMap('userLoggedWithEmailPassword');
    var userLoggedWithFacebook =
        await Store.getMap('userLoggedWithFacebook');

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

    notifyListeners();
    return Future.value();
  }
}
