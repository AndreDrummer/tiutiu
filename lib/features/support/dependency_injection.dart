import 'package:tiutiu/features/support/controller/support_us.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class SupportUsDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => SupportUsController());
  }
}
