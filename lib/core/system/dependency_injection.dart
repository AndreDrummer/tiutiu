import 'package:tiutiu/core/system/controller/system_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class SystemControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => SystemController());
  }
}
