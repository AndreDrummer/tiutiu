import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:tiutiu/providers/auth2.dart';
import 'package:tiutiu/providers/favorites_provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/providers/my_pets_provider.dart';
import 'package:tiutiu/providers/pets_provider.dart';
import 'package:tiutiu/providers/refine_search.dart';
import 'package:tiutiu/providers/user_infos_interests.dart';
import 'package:tiutiu/providers/user_provider.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:tiutiu/screen/home.dart';
import 'package:tiutiu/screen/my_pets.dart';
import 'package:tiutiu/screen/new_pet.dart';
import 'package:tiutiu/screen/pet_detail.dart';
import 'package:tiutiu/screen/refine_search.dart';
import 'package:tiutiu/screen/register.dart';
import 'package:tiutiu/screen/settings.dart';
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
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => Authentication(),
              ),
              ChangeNotifierProvider(
                create: (_) => RefineSearchProvider(),
              ),              
              ChangeNotifierProvider(
                create: (_) => PetsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => MyPetsProvider(),
              ),             
              ChangeNotifierProxyProvider<Authentication, FavoritesProvider>(
                update: (context, auth, favoritesPrevious) =>
                    FavoritesProvider(auth),
                create: (_) => FavoritesProvider(),
              ),
               ChangeNotifierProvider(
                create: (_) => UserInfoOrAdoptInterestsProvider(),
              )
            ],
            child: MaterialApp(
              theme: ThemeData(
                primaryColor: Colors.green,
                accentColor: Colors.yellow,
                scaffoldBackgroundColor: Color(0XFFF9F9F9),
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.white),
                  textTheme: ThemeData.dark().textTheme.copyWith(
                      headline1: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                  )
                ),
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline1: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      button: GoogleFonts.raleway(
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
                // Routes.AUTH_HOME: (ctx) => AnnouncerDetails(),
                Routes.SETTINGS: (ctx) => Settings(),
                Routes.MEUS_PETS: (ctx) => MyPetsScreen(),
                Routes.FAVORITES: (ctx) => Favorites(),
                Routes.REGISTER: (ctx) => Register(),
                Routes.HOME: (ctx) => Home(),                
                Routes.NEW_MAP: (ctx) => NewMap(),
                Routes.CHOOSE_LOCATION: (ctx) => ChooseLocation(),
                Routes.PET_DETAILS: (ctx) => PetDetails(),                
                Routes.SEARCH_REFINE: (ctx) => RefineSearch(),
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
