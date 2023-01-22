import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/adption_form.dart/repository/adoption_form_repository.dart';
import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:share_plus/share_plus.dart';
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

  void setLoading(bool loadingValue, {String loadingText = ''}) {
    _isLoading(loadingValue);
  }

  void nextStep() {
    if (formStep < _STEPS_QTY) {
      _formStep(formStep + 1);
    }
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
    setLoading(true);
    await _adoptionFormRepository.saveForm(adoptionForm: adoptionForm);
    await Future.delayed(Duration(seconds: 1));
    setLoading(false);
  }

  void resetForm() {
    _adoptionForm(AdoptionForm());
    _formStep(0);
    _isEditing(false);
  }

  Future<bool> formExists() async {
    final form = await _adoptionFormRepository.getForm();
    return form != null;
  }

  Future<void> shareForm() async {
    await loadForm();
    await Share.share(adoptionForm.toString());
    Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
    resetForm();
  }

  Future<void> shareEmptyForm() async {
    await Share.share(adoptionForm.toEmpty());
    Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
  }

  Future<void> loadForm() async {
    final form = await _adoptionFormRepository.getForm();
    _adoptionForm(form);
    _isEditing(true);
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
