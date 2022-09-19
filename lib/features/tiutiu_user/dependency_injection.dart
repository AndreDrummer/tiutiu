import 'package:tiutiu/features/pets/services/pet_service.dart';
import 'package:tiutiu/features/tiutiu_user/controller/user_controller.dart';
import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class TiutiuUserControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(
      () => TiutiuUserController(
        TiutiuUserService(
          PetService.instance,
        ),
      ),
    );
  }
}
