import 'package:tiutiu/features/talk_with_us/dependency_injection.dart';
import 'package:tiutiu/features/tiutiu_user/dependency_injection.dart';
import 'package:tiutiu/core/remote_config/dependency_injection.dart';
import 'package:tiutiu/features/sponsored/dependency_injection.dart';
import 'package:tiutiu/features/favorites/dependency_injection.dart';
import 'package:tiutiu/features/dennounce/dependency_injection.dart';
import 'package:tiutiu/features/support/dependency_injection.dart';
import 'package:tiutiu/features/posts/dependency_injection.dart';
import 'package:tiutiu/features/admob/dependency_injection.dart';
import 'package:tiutiu/features/home/dependency_injection.dart';
import 'package:tiutiu/features/auth/dependency_injection.dart';
import 'package:tiutiu/core/location/dependency_injection.dart';
import 'package:tiutiu/features/chat/dependency_injection.dart';
import 'package:tiutiu/core/system/dependency_injection.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';

class SystemInitializer {
  static void initDependencies() {
    _initializeDependencies();
  }

  static void _initializeDependencies() {
    for (var dependency in _dependencies) {
      dependency.init();
    }
  }

  static List<DependencyInjection> _dependencies = [
    AdminRemoteConfigControllerDependency(),
    CurrentLocationControllerDependency(),
    TiutiuUserControllerDependency(),
    FavoritesControllerDependency(),
    SponsoredControllerDependency(),
    DennounceControllerDependency(),
    SystemControllerDependency(),
    AdMobControllerDependency(),
    PostsControllerDependency(),
    HomeControllerDependency(),
    ChatControllerDependency(),
    AuthControllerDependency(),
    TalkWithUsDependency(),
    SupportUsDependency(),
  ];
}
