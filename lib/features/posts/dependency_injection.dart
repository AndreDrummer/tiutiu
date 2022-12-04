import 'package:tiutiu/features/posts/controller/filter_controller.dart';
import 'package:tiutiu/features/posts/repository/posts_repository.dart';
import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class PostsControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => FilterController());
    Get.lazyPut(() => PostService());
    Get.lazyPut(() => PostsRepository(postService: Get.find()));
    Get.lazyPut(() => PostsController(postsRepository: Get.find(), postService: Get.find()));
  }
}
