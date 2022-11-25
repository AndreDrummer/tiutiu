import 'package:tiutiu/features/talk_with_us/dependency_injection.dart';
import 'package:tiutiu/features/tiutiu_user/dependency_injection.dart';
import 'package:tiutiu/features/favorites/dependency_injection.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/location/dependency_injection.dart';
import 'package:tiutiu/features/posts/dependency_injection.dart';
import 'package:tiutiu/features/home/dependency_injection.dart';
import 'package:tiutiu/features/auth/dependency_injection.dart';
import 'package:tiutiu/features/chat/dependency_injection.dart';
import 'package:tiutiu/core/system/dependency_injection.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:tiutiu/core/controllers/controllers.dart';

class TiuTiuInitializer {
  static Future<void> start() async {
    _initializeDependencies();
    await _initializeLocationServices();
  }

  static void _initializeDependencies() {
    for (var dependency in _dependencies) {
      dependency.init();
    }
  }

  static Future<void> _initializeLocationServices() async {
    await currentLocationController.updateGPSStatus();
    await currentLocationController.setUserLocation();
    await StatesAndCities().getUFAndCities();
    await postsController.allPosts();
    await postsController.getCachedAssets();
  }

  static List<DependencyInjection> _dependencies = [
    CurrentLocationControllerDependency(),
    TiutiuUserControllerDependency(),
    FavoritesControllerDependency(),
    SystemControllerDependency(),
    PostsControllerDependency(),
    HomeControllerDependency(),
    ChatControllerDependency(),
    AuthControllerDependency(),
    TalkWithUsDependency(),
  ];
}
