import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class HomeControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => HomeController());
  }
}
