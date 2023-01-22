import 'package:tiutiu/features/adption_form.dart/repository/adoption_form_repository.dart';
import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:get/get.dart';

const int _STEPS_QTY = 5;

class AdoptionFormController extends GetxController {
  AdoptionFormController({required AdoptionFormRepository adoptionFormRepository})
      : _adoptionFormRepository = adoptionFormRepository;

  final AdoptionFormRepository _adoptionFormRepository;

  final Rx<AdoptionForm> _adoptionForm = AdoptionForm().obs;
  final RxBool _isEditing = false.obs;
  final RxBool _isLoading = false.obs;
  final RxInt _formStep = 0.obs;

  AdoptionForm get adoptionForm => _adoptionForm.value;
  bool get isEditing => _isEditing.value;
  bool get isLoading => _isLoading.value;
  int get formStep => _formStep.value;

  void nextStep() {
    if (formStep < _STEPS_QTY) _formStep(formStep + 1);
  }

  void previousStep() {
    if (formStep > 0) {
      _formStep(formStep - 1);
    } else if (formStep == 0) {
      Get.back();
    }
  }

  void setAdoptionForm(AdoptionForm adoptionForm) {
    _adoptionForm(adoptionForm);

    print('New Form ${adoptionForm.toMap()}');
  }

  bool lastStep() => _formStep == _STEPS_QTY;

  Future<void> saveForm() async {
    await _adoptionFormRepository.saveForm(adoptionForm: adoptionForm);
    _adoptionForm(AdoptionForm());
  }

  Future<bool> formExists() async {
    final form = await _adoptionFormRepository.getForm();
    return form != null;
  }

  final List<String> formStepsTitle = [
    AdoptionFormStrings.personalInfo,
    AdoptionFormStrings.referenceContacts,
    AdoptionFormStrings.petInfo,
    AdoptionFormStrings.houseInfo,
    AdoptionFormStrings.financialInfo,
    AdoptionFormStrings.backgroundInfo,
  ];

  final List<String> maritalStatus = [
    '-',
    MaritalStatusStrings.marriedSeparated,
    MaritalStatusStrings.stableUnion,
    MaritalStatusStrings.divorced,
    MaritalStatusStrings.separated,
    MaritalStatusStrings.single,
    MaritalStatusStrings.married,
    MaritalStatusStrings.widower,
  ];

  final List<String> petsType = [
    '-',
    PetTypeStrings.dog,
    PetTypeStrings.cat,
    PetTypeStrings.bird,
  ];
}
