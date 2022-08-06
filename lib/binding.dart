import 'package:get/get.dart';
import 'package:tiutiu/core/controllers/controller_bindings.dart';
import 'package:tiutiu/core/controllers/location_controller.dart';
import 'package:tiutiu/core/models/binding.dart';

List<Binding> _bindings = [
  ControllerBindings(),
];

Future<void> initControllers() async {
  for (var controller in _bindings) {
    controller.init();
  }

  final LocationController _locationController = Get.find();

  _locationController.permissionCheck();
  _locationController.locationServiceIsEnabled();
}
