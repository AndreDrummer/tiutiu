import 'package:get/instance_manager.dart';
import 'package:tiutiu/core/controllers/location_controller.dart';
import 'package:tiutiu/core/models/binding.dart';

class ControllerBindings extends Binding {
  @override
  void init() {
    Get.lazyPut(() => LocationController());
  }
}
