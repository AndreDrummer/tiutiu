import 'package:tiutiu/features/dennounce/controller/user_dennounce_controller.dart';
import 'package:tiutiu/features/dennounce/controller/post_dennounce_controller.dart';
import 'package:tiutiu/features/dennounce/services/dennounce_services.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class DennounceControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => PostDennounceController());
    Get.lazyPut(() => UserDennounceController(dennounceServices: DennounceServices()));
  }
}
