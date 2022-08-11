import 'package:get/get.dart';
import 'package:tiutiu/features/location/dependency_injection.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:tiutiu/features/location/controller/current_location_controller.dart';

List<DependencyInjection> _dependencies = [
  CurrentLocationControllerDependency(),
];

Future<void> initServices() async {
  _initializeDependencies();

  final CurrentLocationController _locationController = Get.find();

  _locationController.updateGPSStatus();
}

void _initializeDependencies() {
  for (var dependency in _dependencies) {
    dependency.init();
  }
}
