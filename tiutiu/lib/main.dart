import 'package:flutter/material.dart';
import './Screen/home.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF46D766),
        accentColor: Color(0xFFd4f224),
        primaryTextTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.black,
              ),
              headline5: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,                
              ),
              button: TextStyle(
                color: Color(0XFFFFFFFF),
                fontSize: 14
              )
            ),
      ),
      home: Home(),
    ),
  );
}
