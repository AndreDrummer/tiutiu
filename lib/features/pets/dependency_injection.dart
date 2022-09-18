import 'package:tiutiu/core/migration/controller/migration_controller.dart';
import 'package:tiutiu/features/my_pets/controller/my_pets_controller.dart';
import 'package:tiutiu/features/full_screen/controller/controller.dart';
import 'package:tiutiu/features/my_pets/services/my_pets_service.dart';
import 'package:tiutiu/core/migration/service/migration_service.dart';
import 'package:tiutiu/features/pets/controller/pets_controller.dart';
import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class PetControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => MigrationController(MigrationService()));
    Get.lazyPut(() => PetsController(PetService.instance));
    Get.lazyPut(() => MyPetsController(MyPetsService()));
    Get.lazyPut(() => FullscreenController());
    Get.lazyPut(() => MyPetsService());
  }
}
