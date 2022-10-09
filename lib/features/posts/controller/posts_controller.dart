import 'package:flutter/widgets.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

class PostsController extends GetxController {
  final GlobalKey<FormState> fullAddressKeyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> nameKeyForm = GlobalKey<FormState>();

  final RxBool _isFullAddress = false.obs;
  final Rx<Pet> _Pet = Pet().obs;
  final RxInt _flowIndex = 0.obs;

  bool get isFullAddress => _isFullAddress.value;
  int get flowIndex => _flowIndex.value;
  Pet get pet => _Pet.value;

  void updatePet(PetEnum property, dynamic data) {
    final petMap = pet.toMap();
    petMap[property.name] = data;

    if (pet.owner == null)
      petMap[PetEnum.owner.name] = tiutiuUserController.tiutiuUser.toMap();

    print('>> $petMap');

    _Pet(Pet.fromMap(petMap));
  }

  void onContinue() {
    switch (flowIndex) {
      case 0:
        if (nameKeyForm.currentState!.validate()) {
          nextStep();
        }
        break;
      case 1:
        print(isFullAddress);
        if (!isFullAddress) {
          nextStep();
        } else if (isFullAddress &&
            fullAddressKeyForm.currentState!.validate()) {
          nextStep();
        }
        break;
    }
  }

  void nextStep() {
    _flowIndex(flowIndex + 1);
  }

  void previousStep() {
    _flowIndex(flowIndex - 1);
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
