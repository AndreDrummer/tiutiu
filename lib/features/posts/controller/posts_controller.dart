import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:get/get.dart';

const int FLOW_STEPS_QTY = 5;

class PostsController extends GetxController {
  final RxBool _isFullAddress = false.obs;
  final RxBool _formIsValid = true.obs;
  final RxInt _flowIndex = 0.obs;
  final Rx<Pet> _pet = Pet().obs;

  bool get existChronicDiseaseInfo =>
      _pet.value.health == PetHealthString.chronicDisease;
  bool get isFullAddress => _isFullAddress.value;
  bool get formIsInInitialState => pet == Pet();
  bool get formIsValid => _formIsValid.value;
  int get flowIndex => _flowIndex.value;
  Pet get pet => _pet.value;

  void updatePet(PetEnum property, dynamic data) {
    final petMap = pet.toMap();
    petMap[property.name] = data;

    if (property == PetEnum.otherCaracteristics) {
      petMap[property.name] = _handlePetOtherCaracteristics(data);
    } else if (pet.owner == null) {
      petMap[PetEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();
    }

    print('>> $petMap');

    _pet(Pet.fromMap(petMap));
  }

  List _handlePetOtherCaracteristics(String incomingCaracteristic) {
    List caracteristics = [];
    caracteristics.addAll(pet.otherCaracteristics);

    if (caracteristics.contains(incomingCaracteristic)) {
      caracteristics.remove(incomingCaracteristic);
    } else {
      caracteristics.add(incomingCaracteristic);
    }

    return caracteristics;
  }

  void onContinue() {
    PostFormValidator validator = PostFormValidator(pet);
    // nextStep();

    switch (flowIndex) {
      case 0:
        _formIsValid(validator.isStep1Valid());
        break;
      case 1:
        _formIsValid(validator.isStep2Valid(existChronicDiseaseInfo));
        break;
      case 2:
        _formIsValid(validator.isStep3Valid());
        break;
      case 3:
        _formIsValid(validator.isStep4Valid(isFullAddress));
        break;
      case 4:
        _formIsValid(validator.isStep5Valid());
        break;
      case 5:
        _formIsValid(
          validator.isFormIsValid(
            existChronicDiseaseInfo: existChronicDiseaseInfo,
            isFullAddress: isFullAddress,
          ),
        );
        break;
    }

    if (formIsValid) nextStep();
  }

  void clearForm() {
    _isFullAddress(false);
    _formIsValid(true);
    _pet(Pet());
  }

  void nextStep() {
    if (flowIndex < FLOW_STEPS_QTY) _flowIndex(flowIndex + 1);
  }

  void previousStep() {
    if (flowIndex == 0) {
      clearForm();
      homeController.bottomBarIndex = 0;
    } else
      _flowIndex(flowIndex - 1);
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
