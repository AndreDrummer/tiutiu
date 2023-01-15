import 'package:tiutiu/features/delete_account/controller/delete_account.dart';
import 'package:tiutiu/features/tiutiu_user/services/tiutiu_user_service.dart';
import 'package:tiutiu/features/tiutiu_user/controller/user_controller.dart';
import 'package:tiutiu/features/more/controller/more_controller.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import '../delete_account/service/delete_account_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';

class TiutiuUserControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => TiutiuUserService());
    Get.lazyPut(() => PostService());
    Get.lazyPut(() => TiutiuUserController(Get.find()));
    Get.lazyPut(() => MoreController());
    Get.lazyPut(() => DeleteAccountService(tiutiuUserService: Get.find(), postService: Get.find()));
    Get.lazyPut(() => DeleteAccountController(deleteAccountService: Get.find()));
  }
}
