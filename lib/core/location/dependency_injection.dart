import 'package:get/instance_manager.dart';
import 'package:tiutiu/core/location/controller/current_location_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';

class CurrentLocationControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => CurrentLocationController());
  }
}
