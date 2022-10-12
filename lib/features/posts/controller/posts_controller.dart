import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final GlobalKey<FormState> fullAddressKeyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> nameKeyForm = GlobalKey<FormState>();
  final RxBool _isFullAddress = false.obs;
  final RxBool _formIsValid = true.obs;
  final Rx<Pet> _pet = Pet().obs;
  final RxInt _flowIndex = 0.obs;

  bool get isFullAddress => _isFullAddress.value;
  bool get formIsValid => _formIsValid.value;
  int get flowIndex => _flowIndex.value;
  Pet get pet => _pet.value;

  bool get formIsInInitialState => pet == Pet();

  void updatePet(PetEnum property, dynamic data) {
    final petMap = pet.toMap();
    petMap[property.name] = data;

    if (pet.owner == null)
      petMap[PetEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();

    print('>> $petMap');

    _pet(Pet.fromMap(petMap));
  }

  void onContinue() {
    nextStep();
    // switch (flowIndex) {
    //   case 0:
    //     if (checkIfFormIsValid()) {
    //     }
    //     break;
    //   case 1:
    //     print(isFullAddress);
    //     if (!isFullAddress) {
    //       nextStep();
    //     } else if (isFullAddress &&
    //         fullAddressKeyForm.currentState!.validate()) {
    //       nextStep();
    //     }
    //     break;
    // }
  }

  bool checkIfFormIsValid() {
    bool isValid = false;

    isValid = nameKeyForm.currentState!.validate() &&
        // pet.type.isNotEmptyNeighterNull() &&
        // pet.color.isNotEmptyNeighterNull() &&
        // pet.breed.isNotEmptyNeighterNull() &&
        // pet.gender.isNotEmptyNeighterNull() &&
        // pet.details.isNotEmptyNeighterNull() &&
        pet.size.isNotEmptyNeighterNull();

    _formIsValid(isValid);

    return isValid;
  }

  void clearForm() {
    _isFullAddress(false);
    _formIsValid(true);
    _pet(Pet());
  }

  void nextStep() {
    _flowIndex(flowIndex + 1);
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
