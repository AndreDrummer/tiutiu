import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  String _expireDateToken;
  String _userId;

  String get token => _token;
  String get expireDateToken => _expireDateToken;
  String get userId => _userId;

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
  }
}
