import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/widgets.dart';

final GlobalKey<FormState> diaseaseForm = GlobalKey<FormState>();
final GlobalKey<FormState> nameKeyForm = GlobalKey<FormState>();

class PostFormValidator {
  PostFormValidator(Post pet) : _pet = pet;

  final Post _pet;

  bool isStep1Valid(existChronicDiseaseInfo) {
    bool isValid = nameKeyForm.currentState!.validate() &&
        (_pet as Pet).health.isNotEmptyNeighterNull() &&
        (_pet as Pet).size.isNotEmptyNeighterNull();

    if (existChronicDiseaseInfo) {
      isValid = isValid && diaseaseForm.currentState!.validate();
    }

    return isValid;
  }

  bool isStep2Valid() {
    bool isValid = (_pet as Pet).breed.isNotEmptyNeighterNull() &&
        (_pet as Pet).color.isNotEmptyNeighterNull() &&
        (_pet as Pet).gender.isNotEmptyNeighterNull() &&
        _pet.description.isNotEmptyNeighterNull();

    return isValid;
  }

  bool isStep3Valid() {
    // Always valid: caracteristics are optional.

    return true;
  }

  bool isStep4Valid(bool isFullAddress) {
    bool isValid = _pet.state.isNotEmptyNeighterNull() && _pet.city.isNotEmptyNeighterNull();

    if (isFullAddress) {
      isValid = isValid && _pet.describedAddress.isNotEmptyNeighterNull();
    }

    return isValid;
  }

  bool isStep5Valid() {
    bool isValid = _pet.photos.isNotEmpty;
    return isValid;
  }
}
