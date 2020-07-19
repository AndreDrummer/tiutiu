import 'dart:async';
import 'dart:convert';
import 'package:tiutiu/Exceptions/auth_exceptions.dart';
import 'package:tiutiu/data/store_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDateToken;
  String _userId;
  Timer _timeToLogout;

  String get token {
    if(_token != null && _expireDateToken != null && _expireDateToken.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  String get userId => isAuth ? _userId : null;  
  
  bool get isAuth => token != null;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAX9SWKqAIAZ0UvUGW8p8jtkhf4_gBzFKo';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final responseBody = json.decode(response.body);
    print(responseBody);
    if (responseBody["error"] != null) {
      throw AuthException(
        responseBody["error"]["message"]
      );    
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expireDateToken = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseBody["expiresIn"],
          ),
        ),
      );
    }

    Store.saveMap(
      'userData',
      {
        'token': token,
        'expireDateToken': _expireDateToken.toIso8601String(),
        'userId': userId
      },
    );

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  Future<void> signup(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');    
  }

  Future<void> tryLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');
    DateTime expireDate;

    if (userData == null) {
      return Future.value();
    }

    expireDate = DateTime.parse(userData['expireDateToken']);

    if (expireDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _token = userData['token'];
    _expireDateToken = expireDate;
    _userId = userData['userId'];

    _autoLogout();
    notifyListeners();

    return Future.value();
  }

  void logout() {
    print('Saindo');
    _token = null;
    _expireDateToken = null;
    _userId = null;
    if (_timeToLogout != null) {
      _timeToLogout.cancel();
      _timeToLogout = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_timeToLogout != null) {
      _timeToLogout.cancel();
    }
    final secondsToLogout = _expireDateToken.difference(DateTime.now()).inSeconds;
    _timeToLogout = Timer(Duration(seconds: secondsToLogout), logout);
  }
}
