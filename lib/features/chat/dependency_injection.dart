import 'package:tiutiu/features/chat/controller/chat_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/chat/services/chat_service.dart';

class ChatControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => ChatService());
    Get.lazyPut(() => ChatController(chatService: Get.find()));
  }
}
