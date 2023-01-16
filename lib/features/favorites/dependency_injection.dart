import 'package:tiutiu/features/favorites/controller/favorites_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class FavoritesControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => SavedsController());
  }
}
