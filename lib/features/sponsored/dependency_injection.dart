import 'package:tiutiu/features/sponsored/controller/sponsored_controller.dart';
import 'package:tiutiu/features/sponsored/services/sponsored_services.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class SponsoredControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => SponsoredController(sponsoredServices: SponsoredServices()));
  }
}
