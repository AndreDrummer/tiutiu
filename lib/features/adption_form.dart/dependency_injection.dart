import 'package:tiutiu/features/adption_form.dart/controller/adoption_form_controller.dart';
import 'package:tiutiu/features/adption_form.dart/repository/adoption_form_repository.dart';
import 'package:tiutiu/core/models/dependency_injection.dart';
import 'package:get/get.dart';

class AdoptionFormControllerDependency extends DependencyInjection {
  @override
  void init() {
    Get.lazyPut(() => AdoptionFormController(adoptionFormRepository: AdoptionFormRepository()));
  }
}
