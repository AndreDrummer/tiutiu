import 'package:tiutiu/features/talk_with_us/controller/feedback.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/instance_manager.dart';
import 'package:tiutiu/features/talk_with_us/service/feedback.dart';

class TalkWithUsDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => FeedbackService());
    Get.lazyPut(() => FeedbackController(feedbackService: Get.find()));
  }
}
