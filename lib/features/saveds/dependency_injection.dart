import 'package:tiutiu/features/saveds/controller/saveds_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class FavoritesControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => SavedsController());
  }
}
