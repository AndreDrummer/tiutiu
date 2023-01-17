import 'package:tiutiu/features/saveds/controller/saveds_controller.dart';
import 'package:tiutiu/features/saveds/services/saved_services.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class SavedsControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(
      () => SavedsController(
        savedServices: SavedServices(),
        postsServices: PostService(),
      ),
    );
  }
}
