import 'package:tiutiu/features/pets/controller/pets_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class PetControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => PetsController());
  }
}
