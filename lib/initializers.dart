import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/features/refine_search/dependency_injection.dart';
import 'package:tiutiu/features/tiutiu_user/dependency_injection.dart';
import 'package:tiutiu/features/location/dependency_injection.dart';
import 'package:tiutiu/features/posts/dependency_injection.dart';
import 'package:tiutiu/features/system/dependency_injection.dart';
import 'package:tiutiu/features/home/dependency_injection.dart';
import 'package:tiutiu/features/auth/dependency_injection.dart';
import 'package:tiutiu/features/chat/dependency_injection.dart';
import 'package:tiutiu/features/pets/dependency_injection.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:tiutiu/core/data/location_data_strings.dart';
import 'package:get/get.dart';

class TiuTiuInitializer {
  static Future<void> start() async {
    _initializeDependencies();
    await _initializeLocationServices();
  }

  static void _initializeDependencies() {
    for (var dependency in _dependencies) {
      dependency.init();
    }
  }

  static Future<void> _initializeLocationServices() async {
    final CurrentLocationController _locationController = Get.find();

    await _locationController.updateGPSStatus();
    await _locationController.setUserLocation();
    await DataLocalStrings().getUFAndCities();
  }

  static List<DependencyInjection> _dependencies = [
    CurrentLocationControllerDependency(),
    RefineSearchControllerDependency(),
    TiutiuUserControllerDependency(),
    SystemControllerDependency(),
    PostsControllerDependency(),
    HomeControllerDependency(),
    ChatControllerDependency(),
    AuthControllerDependency(),
    PetControllerDependency(),
  ];
}
