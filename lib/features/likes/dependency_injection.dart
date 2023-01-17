import 'package:tiutiu/features/likes/controller/likes_controller.dart';
import 'package:tiutiu/features/likes/services/likes_service.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class LikesControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(
      () => LikesController(
        postsServices: PostService(),
        likesService: LikesService(),
      ),
    );
  }
}
