import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

final GlobalKey<FormState> diaseaseForm = GlobalKey<FormState>();
final GlobalKey<FormState> breedFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> nameKeyForm = GlobalKey<FormState>();

class PostFormValidator {
  PostFormValidator(Post pet) : post = pet;

  final Post post;

  bool isStep1Valid(existChronicDiseaseInfo) {
    bool isValid = nameKeyForm.currentState!.validate() &&
        (post as Pet).health.isNotEmptyNeighterNull() &&
        (post as Pet).gender.isNotEmptyNeighterNull() &&
        (post as Pet).size.isNotEmptyNeighterNull();

    if (existChronicDiseaseInfo) {
      isValid = isValid && diaseaseForm.currentState!.validate();
    }

    return isValid;
  }

  bool isStep2Valid() {
    bool isValid = (post as Pet).breed.isNotEmptyNeighterNull() &&
        (post as Pet).color.isNotEmptyNeighterNull() &&
        (post as Pet).description.isNotEmptyNeighterNull();

    if (post.type == AppLocalizations.of(Get.context!)!.other) {
      isValid = breedFormKey.currentState!.validate();
    }

    return isValid;
  }

  bool isStep3Valid() => true;

  bool isStep4Valid() => true;

  bool isStep5Valid() {
    bool isValid = post.photos.isNotEmpty;
    return isValid;
  }
}
