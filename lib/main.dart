import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/mapa.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/show_bottom.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/screen/donates.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:tiutiu/screen/new_pet.dart';
import 'package:tiutiu/screen/pet_detail.dart';
import './utils/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Directionality(
            child: MediaQuery(
              data: MediaQueryData(),
              child: Center(child: Text('${snapshot.error}')),
            ),
            textDirection: TextDirection.ltr,
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Location(),
              ),
              ChangeNotifierProvider(
                create: (_) => Authentication(),
              ),
              ChangeNotifierProvider(
                create: (_) => ShowBottomNavigator(),
              ),
              ChangeNotifierProvider(
                create: (_) => PetsProvider(),
              )
            ],
            child: MaterialApp(
              theme: ThemeData(
                primaryColor: Colors.green,
                accentColor: Color(0xFF00FF00),
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline1: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      button: GoogleFonts.roboto(
                        color: Color(0XFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
              ),
              debugShowCheckedModeBanner: false,
              routes: {
                Routes.NOVOPET: (ctx) => NovoPet(),
                Routes.AUTH_HOME: (ctx) => AuthOrHome(),
                Routes.HOME: (ctx) => Home(),
                Routes.DOADOS: (ctx) => Donate(),
                Routes.MAPA: (ctx) => Mapa(),
                Routes.CHOOSE_LOCATION: (ctx) => ChooseLocation(),
                Routes.PET_DETAILS: (ctx) => PetDetails(),
              },
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
