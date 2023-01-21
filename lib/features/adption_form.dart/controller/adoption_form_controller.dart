import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/adption_form.dart/services/adoption_form_service.dart';
import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:get/get.dart';

const int _STEPS_QTY = 5;

class AdoptionFormController extends GetxController {
  AdoptionFormController({required AdoptionFormServices adoptionFormServices})
      : _adoptionFormServices = adoptionFormServices;

  final AdoptionFormServices _adoptionFormServices;

  final Rx<AdoptionForm> _adoptionForm = AdoptionForm().obs;
  final RxBool _isEditing = false.obs;
  final RxBool _isLoading = false.obs;
  final RxInt _formStep = 0.obs;

  AdoptionForm get adoptionForm => _adoptionForm.value;
  bool get isEditing => _isEditing.value;
  bool get isLoading => _isLoading.value;
  int get formStep => _formStep.value;

  void nextStep() {
    if (formStep <= _STEPS_QTY) _formStep(formStep + 1);
  }

  void previousStep() {
    if (formStep > 0) _formStep(formStep - 1);
    if (formStep == 0) Get.back();
  }

  void setAdoptionForm(AdoptionForm adoptionForm) {
    _adoptionForm(adoptionForm);

    print('New Form ${adoptionForm.toMap()}');
  }

  bool lastStep() => _formStep == _STEPS_QTY - 1;

  Future<void> submitForm() async {
    return await _adoptionFormServices.submitForm(
      userId: tiutiuUserController.tiutiuUser.uid!,
      adoptionForm: adoptionForm,
    );
  }

  List<String> get formStepsTitle => _formStepsTitle;

  List<String> _formStepsTitle = [
    AdoptionFormStrings.personalInfo,
    AdoptionFormStrings.petInfo,
    AdoptionFormStrings.houseInfo,
    AdoptionFormStrings.financialInfo,
    AdoptionFormStrings.backgroundInfo,
  ];

  List<String> get maritalStatus => _maritalStatus;

  List<String> _maritalStatus = [
    '-',
    MaritalStatusStrings.marriedSeparated,
    MaritalStatusStrings.stableUnion,
    MaritalStatusStrings.divorced,
    MaritalStatusStrings.separated,
    MaritalStatusStrings.single,
    MaritalStatusStrings.married,
    MaritalStatusStrings.widower,
  ];
}
