import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/donates.dart';
import 'package:tiutiu/screen/newPet.dart';
import './utils/routes.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => Location(),
      )
    ],
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF46D766),
        accentColor: Color(0xFFd4f224),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(color: Colors.white, fontSize: 14),
              headline5: TextStyle(color: Colors.black26, fontSize: 14),
              headline4: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
              button: TextStyle(color: Color(0XFFFFFFFF), fontSize: 14),
            ),
      ),
      home: AuthScreen(),
      routes: {
        Routes.NOVOPET: (ctx) => NovoPet(),
        Routes.DOADOS: (ctx) => Donate(),
        Routes.AUTH: (ctx) => AuthScreen(),
      },
    ),
    )
  );
}
