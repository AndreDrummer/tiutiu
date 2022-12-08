import 'package:tiutiu/core/system/controller/system_controller.dart';
import 'package:tiutiu/core/system/service/system_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class SystemControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => SystemService());
    Get.lazyPut(() => SystemController(systemService: Get.find()));
  }
}
