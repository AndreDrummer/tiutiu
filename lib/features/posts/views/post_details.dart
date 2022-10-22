import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        children: [
          _breed(),
          _spacer(),
          _color(),
          _spacer(),
          _gender(),
          _spacer(),
          _descriptionLabel(),
          _descriptionInputText(),
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

  OneLineText _descriptionLabel() {
    return OneLineText(
      text: PostFlowStrings.addDescription,
      widgetAlignment: Alignment(-0.92, 1),
      fontWeight: FontWeight.w500,
      color: AppColors.secondary,
    );
  }

  Padding _descriptionInputText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: TextArea(
        isInErrorState:
            !postsController.post.description.isNotEmptyNeighterNull() &&
                !postsController.formIsValid,
        initialValue: postsController.post.description,
        labelText: AppStrings.jotSomethingDown,
        maxLines: 4,
        onChanged: (description) {
          postsController.updatePet(PetEnum.description, description);
        },
      ),
    );
  }

  Widget _spacer() => SizedBox(height: 32.0.h);
}
