import 'package:tiutiu/core/remote_config/services/admin_remote_config_services.dart';
import 'package:tiutiu/core/remote_config/controller/admin_remote_config.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class AdminRemoteConfigControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => AdminRemoteConfigController(adminRemoteConfigServices: AdminRemoteConfigServices()));
  }
}
