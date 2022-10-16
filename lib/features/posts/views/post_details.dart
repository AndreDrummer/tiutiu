import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          SizedBox(height: 4.0.h),
          _breed(),
          _spacer(),
          _color(),
          _spacer(),
          _health(),
          _gender(),
        ],
      ),
    );
  }

  UnderlineInputDropdown _breed() {
    return UnderlineInputDropdown(
      isInErrorState: !postsController.post.breed.isNotEmptyNeighterNull() &&
          !postsController.formIsValid,
      initialValue: postsController.post.breed,
      onChanged: (breed) {
        postsController.updatePet(PetEnum.breed, breed);
      },
      items: DummyData.breeds[postsController.post.type]!,
      labelText: PetDetailsStrings.breed,
      fontSize: 14.0.sp,
    );
  }

  UnderlineInputDropdown _color() {
    return UnderlineInputDropdown(
      isInErrorState: !postsController.post.color.isNotEmptyNeighterNull() &&
          !postsController.formIsValid,
      initialValue: postsController.post.color,
      onChanged: (color) {
        postsController.updatePet(PetEnum.color, color);
      },
      labelText: PetDetailsStrings.color,
      items: DummyData.color,
      fontSize: 14.0.sp,
    );
  }

  Widget _health() {
    return AnimatedContainer(
      height: postsController.existChronicDiseaseInfo ? 136.0.h : 64.0.h,
      margin: EdgeInsets.only(bottom: 8.0.h),
      duration: Duration(milliseconds: 500),
      child: ListView(
        children: [
          UnderlineInputDropdown(
            isInErrorState:
                !postsController.post.health.isNotEmptyNeighterNull() &&
                    !postsController.formIsValid,
            initialValue: postsController.post.health.toString(),
            onChanged: (health) {
              postsController.updatePet(PetEnum.health, health);
            },
            labelText: PetDetailsStrings.health,
            items: DummyData.health,
            fontSize: 14.0.sp,
          ),
          _chronicDiseaseInfo(),
        ],
      ),
    );
  }

  Visibility _chronicDiseaseInfo() {
    return Visibility(
      visible: postsController.existChronicDiseaseInfo,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Form(
                key: diaseaseForm,
                child: TextArea(
                  isInErrorState: !postsController.post.chronicDiseaseInfo
                          .isNotEmptyNeighterNull() &&
                      !postsController.formIsValid,
                  maxLines: 1,
                  onChanged: (chronicDiseaseInfo) {
                    postsController.updatePet(
                      PetEnum.chronicDiseaseInfo,
                      chronicDiseaseInfo,
                    );
                  },
                  initialValue: postsController.post.chronicDiseaseInfo,
                  validator: postsController.existChronicDiseaseInfo
                      ? Validators.verifyEmpty
                      : null,
                  labelText: PostFlowStrings.describeDiseaseType,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  UnderlineInputDropdown _gender() {
    return UnderlineInputDropdown(
      isInErrorState: !postsController.post.gender.isNotEmptyNeighterNull() &&
          !postsController.formIsValid,
      initialValue: postsController.post.gender.toString(),
      onChanged: (gender) {
        postsController.updatePet(PetEnum.gender, gender);
      },
      labelText: PetDetailsStrings.sex,
      items: DummyData.gender,
      fontSize: 14.0.sp,
    );
  }

  Widget _spacer() => AnimatedContainer(
        height: postsController.existChronicDiseaseInfo ? 16.0.h : 32.0.h,
        duration: Duration(milliseconds: 500),
      );
}
