import 'package:tiutiu/core/system/controller/app_controller.dart';
import 'package:tiutiu/core/system/service/app_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class SystemControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => AppService());
    Get.lazyPut(() => AppController(systemService: Get.find()));
  }
}
