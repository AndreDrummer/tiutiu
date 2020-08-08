import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/mapa.dart';
import 'package:tiutiu/providers/auth.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/show_bottom.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/screen/donates.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:tiutiu/screen/new_pet.dart';
import './utils/routes.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => Location(),
      ),
      ChangeNotifierProvider(
        create: (_) => Auth(),
      ),
      ChangeNotifierProvider(
        create: (_) => ShowBottomNavigator(),
      )
    ],
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF46D766),
        accentColor: Color(0xFFFF4500),
        textTheme: ThemeData.light().textTheme.copyWith(              
              headline1: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
              button: TextStyle(color: Color(0XFFFFFFFF), fontSize: 14, fontWeight: FontWeight.w700),
            ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        Routes.NOVOPET: (ctx) => NovoPet(),
        Routes.AUTH_HOME: (ctx) => AuthOrHome(),
        Routes.HOME: (ctx) =>  Home(),
        Routes.DOADOS: (ctx) => Donate(),
        Routes.AUTH: (ctx) => AuthScreen(),
        Routes.MAPA: (ctx) => Mapa(),
        Routes.CHOOSE_LOCATION: (ctx) => ChooseLocation(),
      },
    ),
    )
  );
}
