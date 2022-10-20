import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';

class PostsControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => PostsController(postService: PostService()));
  }
}
