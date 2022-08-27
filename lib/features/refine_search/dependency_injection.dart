import 'package:tiutiu/features/refine_search/controller/refine_search_controller.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class RefineSearchControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => RefineSearchController());
  }
}
