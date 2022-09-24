import 'package:tiutiu/screen/interested_information_list.dart';
import 'package:tiutiu/features/chat/screens/chat_screen.dart';
import 'package:tiutiu/features/chat/screens/chat_tabs.dart';
import 'package:tiutiu/features/auth/views/start_screen.dart';
import 'package:tiutiu/features/pets/views/pet_detail.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/app_bootstrap.dart';
import 'package:tiutiu/screen/informantes_screen.dart';
import 'package:tiutiu/features/home/views/home.dart';
import 'package:tiutiu/screen/choose_location.dart';
import 'package:tiutiu/screen/notifications.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:tiutiu/screen/register.dart';
import 'package:tiutiu/screen/settings.dart';
import 'package:tiutiu/Widgets/new_map.dart';
import 'package:tiutiu/screen/my_pets.dart';
import 'package:tiutiu/screen/about.dart';
import 'package:flutter/material.dart';

class RouterGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.root:
        return MaterialPageRoute(
          builder: (_) => AppBootstrap(),
        );
      case Routes.auth:
        return MaterialPageRoute(
          builder: (_) => StartScreen(),
        );

      case Routes.chat:
        return MaterialPageRoute(
          builder: (_) => ChatScreen(),
        );
      case Routes.chat_list:
        return MaterialPageRoute(
          builder: (_) => ChatTab(),
        );
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => AppSettings(),
        );
      case Routes.about:
        return MaterialPageRoute(
          builder: (_) => About(),
        );
      case Routes.my_pets:
        return MaterialPageRoute(
          builder: (_) => MyPetsScreen(),
        );
      case Routes.favorites:
        return MaterialPageRoute(
          builder: (_) => Favorites(),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => Register(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case Routes.new_map:
        return MaterialPageRoute(
          builder: (_) => NewMap(),
        );
      case Routes.pet_location_picker:
        return MaterialPageRoute(
          builder: (_) => ChooseLocation(),
        );
      case Routes.pet_details:
        return MaterialPageRoute(
          builder: (_) => PetDetails(),
        );
      case Routes.interested_list:
        return MaterialPageRoute(
          builder: (_) => InterestedList(),
        );
      case Routes.info:
        return MaterialPageRoute(
          builder: (_) => InformantesScreen(),
        );
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => NotificationScreen(),
        );
    }
    return null;
  }
}
