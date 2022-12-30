import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';
import 'package:tiutiu/features/dennounce/controller/post_dennounce._controller.dart';

class PostDennounceControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => PostDennounceController());
  }
}
