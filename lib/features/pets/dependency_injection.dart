import 'package:tiutiu/features/my_pets/controller/my_pets_controller.dart';
import 'package:tiutiu/features/my_pets/services/my_pets_service.dart';
import 'package:tiutiu/features/pets/controller/pets_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class PetControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => MyPetsController(MyPetsService()));
    Get.lazyPut(() => PetsController());
  }
}
