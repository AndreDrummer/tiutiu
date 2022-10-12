import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView(
          children: [
            UnderlineInputDropdown(
              isInErrorState:
                  !postsController.pet.breed.isNotEmptyNeighterNull() &&
                      !postsController.formIsValid,
              initialValue: postsController.pet.breed,
              onChanged: (breed) {
                postsController.updatePet(PetEnum.breed, breed);
              },
              items: DummyData.breeds[postsController.pet.type]!,
              labelText: PetDetailsStrings.breed,
              fontSize: 14.0.sp,
            ),
            _spacer(),
            UnderlineInputDropdown(
              isInErrorState:
                  !postsController.pet.color.isNotEmptyNeighterNull() &&
                      !postsController.formIsValid,
              initialValue: postsController.pet.color,
              onChanged: (color) {
                postsController.updatePet(PetEnum.color, color);
              },
              labelText: PetDetailsStrings.color,
              items: DummyData.color,
              fontSize: 14.0.sp,
            ),
            _spacer(),
            UnderlineInputDropdown(
              initialValue: postsController.pet.health.toString(),
              onChanged: (health) {
                postsController.updatePet(PetEnum.health, health);
              },
              labelText: PetDetailsStrings.health,
              items: DummyData.health,
              fontSize: 14.0.sp,
            ),
            _spacer(),
            UnderlineInputDropdown(
              initialValue: postsController.pet.gender.toString(),
              onChanged: (gender) {
                postsController.updatePet(PetEnum.gender, gender);
              },
              labelText: PetDetailsStrings.sex,
              items: DummyData.gender,
              fontSize: 14.0.sp,
            ),
            _spacer(),
          ],
        ),
      ),
    );
  }

  SizedBox _spacer() => SizedBox(height: 32.0.h);
}
