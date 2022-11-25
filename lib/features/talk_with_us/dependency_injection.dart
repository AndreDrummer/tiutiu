import 'package:tiutiu/features/talk_with_us/controller/talk_with_us.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class TalkWithUsDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => TalkWithUsController());
  }
}
