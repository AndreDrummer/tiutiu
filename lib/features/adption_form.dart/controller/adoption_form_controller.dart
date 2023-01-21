import 'package:tiutiu/features/adption_form.dart/services/adoption_form_service.dart';
import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:get/get.dart';

class AdoptionFormController extends GetxController {
  AdoptionFormController({required AdoptionFormServices adoptionFormServices})
      : _adoptionFormServices = adoptionFormServices;

  final AdoptionFormServices _adoptionFormServices;

  final Rx<AdoptionForm> _adoptionForm = AdoptionForm().obs;

  AdoptionForm get adoptionForm => _adoptionForm.value;

  Future<void> submitForm() async {
    return await _adoptionFormServices.submitForm(
      userId: tiutiuUserController.tiutiuUser.uid!,
      adoptionForm: adoptionForm,
    );
  }
}
