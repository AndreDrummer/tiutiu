import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: EdgeInsets.only(top: 8.0.h),
        children: [
          _breed(),
          _spacer(),
          _color(),
          _spacer(),
          _gender(),
          SizedBox(height: 16.0.h),
          _descriptionLabel(),
          _descriptionInputText(),
        ],
      ),
    );
  }

  UnderlineInputDropdown _breed() {
    return UnderlineInputDropdown(
      isInErrorState: !(postsController.post as Pet).breed.isNotEmptyNeighterNull() && !postsController.formIsValid,
      initialValue: (postsController.post as Pet).breed,
      onChanged: (breed) {
        postsController.updatePost(PetEnum.breed.name, breed);
      },
      items: DummyData.breeds[postsController.post.type]!,
      labelText: PostDetailsStrings.breed,
      fontSize: 14.0,
    );
  }

  UnderlineInputDropdown _color() {
    final petType = (postsController.post as Pet).type;
    late List<String> items;

    switch (petType) {
      case PetTypeStrings.dog:
        items = DummyData.dogColors;
        break;

      case PetTypeStrings.cat:
        items = DummyData.catColors;
        break;

      default:
        items = DummyData.allColors;
    }

    return UnderlineInputDropdown(
      isInErrorState: !(postsController.post as Pet).color.isNotEmptyNeighterNull() && !postsController.formIsValid,
      initialValue: (postsController.post as Pet).color,
      onChanged: (color) {
        postsController.updatePost(PetEnum.color.name, color);
      },
      labelText: PostDetailsStrings.color,
      items: items,
      fontSize: 14.0,
    );
  }

  UnderlineInputDropdown _gender() {
    final petType = (postsController.post as Pet).type;
    late List<String> items;

    switch (petType) {
      case PetTypeStrings.dog:
      case PetTypeStrings.cat:
        items = DummyData.gender.sublist(0, 3);
        break;

      default:
        items = DummyData.gender;
    }

    return UnderlineInputDropdown(
      isInErrorState: !(postsController.post as Pet).gender.isNotEmptyNeighterNull() && !postsController.formIsValid,
      initialValue: (postsController.post as Pet).gender.toString(),
      onChanged: (gender) {
        postsController.updatePost(PetEnum.gender.name, gender);
      },
      labelText: PostDetailsStrings.sex,
      items: items,
      fontSize: 14.0,
    );
  }

  OneLineText _descriptionLabel() {
    return OneLineText(
      text: PostFlowStrings.addDescription,
      widgetAlignment: Alignment(-0.85, 1),
      fontWeight: FontWeight.w500,
      color: AppColors.secondary,
    );
  }

  Padding _descriptionInputText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: TextArea(
        isInErrorState: !postsController.post.description.isNotEmptyNeighterNull() && !postsController.formIsValid,
        initialValue: postsController.post.description,
        labelText: AppStrings.jotSomethingDown,
        maxLines: 4,
        onChanged: (description) {
          postsController.updatePost(PostEnum.description.name, description);
        },
      ),
    );
  }

  Widget _spacer() => SizedBox(height: 32.0.h);
}
