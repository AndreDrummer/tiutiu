import 'package:tiutiu/features/admob/controller/admob_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class AdMobControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => AdMobController());
  }
}
