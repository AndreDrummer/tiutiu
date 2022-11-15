import 'package:tiutiu/features/tiutiu_user/dependency_injection.dart';
import 'package:tiutiu/features/favorites/dependency_injection.dart';
import 'package:tiutiu/features/location/dependency_injection.dart';
import 'package:tiutiu/features/system/dependency_injection.dart';
import 'package:tiutiu/features/posts/dependency_injection.dart';
import 'package:tiutiu/features/home/dependency_injection.dart';
import 'package:tiutiu/features/auth/dependency_injection.dart';
import 'package:tiutiu/features/chat/dependency_injection.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/data/states_and_cities.dart';

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
    await postsController.loadPosts();
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
  ];
}
