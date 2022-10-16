import 'package:flutter/widgets.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';

final GlobalKey<FormState> fullAddressKeyForm = GlobalKey<FormState>();
final GlobalKey<FormState> diaseaseForm = GlobalKey<FormState>();
final GlobalKey<FormState> nameKeyForm = GlobalKey<FormState>();

class PostFormValidator {
  PostFormValidator(Pet pet) : _pet = pet;

  final Pet _pet;

  bool isStep1Valid() {
    bool isValid = nameKeyForm.currentState!.validate() &&
        _pet.type.isNotEmptyNeighterNull() &&
        _pet.size.isNotEmptyNeighterNull();

    return isValid;
  }

  bool isStep2Valid(existChronicDiseaseInfo) {
    bool isValid = _pet.breed.isNotEmptyNeighterNull() &&
        _pet.color.isNotEmptyNeighterNull() &&
        _pet.health.isNotEmptyNeighterNull() &&
        _pet.gender.isNotEmptyNeighterNull();

    if (existChronicDiseaseInfo) {
      isValid = isValid && diaseaseForm.currentState!.validate();
    }

    return isValid;
  }

  bool isStep3Valid() {
    bool isValid = _pet.description.isNotEmptyNeighterNull();
    return isValid;
  }

  bool isStep4Valid(bool isFullAddress) {
    bool isValid = _pet.state.isNotEmptyNeighterNull() &&
        _pet.city.isNotEmptyNeighterNull();

    if (isFullAddress) {
      isValid = isValid && fullAddressKeyForm.currentState!.validate();
    }

    return isValid;
  }

  bool isStep5Valid() {
    bool isValid = _pet.photos.isNotEmpty;
    return isValid;
  }
}
