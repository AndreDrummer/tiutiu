import 'package:tiutiu/features/adption_form.dart/controller/adoption_form_controller.dart';
import 'package:tiutiu/features/adption_form.dart/services/adoption_form_service.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class AdoptionFormControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => AdoptionFormController(adoptionFormServices: AdoptionFormServices()));
  }
}
