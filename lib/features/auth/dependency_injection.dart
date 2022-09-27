import 'package:tiutiu/features/auth/controller/auth_controller.dart';
import 'package:tiutiu/features/auth/service/auth_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class AuthControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => AuthController(authService: AuthService()));
  }
}
