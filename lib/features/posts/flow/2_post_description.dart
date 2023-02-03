import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/underline_text.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthsList = List<String>.generate(13, (index) => '$index');
    final yearsList = List.generate(22, (index) => '$index');

    return Obx(
      () => ListView(
        padding: EdgeInsets.only(top: 8.0.h),
        children: [
          _breed(),
          _spacer(),
          _color(),
          _spacer(),
          _petAge(yearsList, monthsList),
          _spacer(),
        ],
      ),
    );
  }

  Widget _breed() {
    final postType = postsController.post.type;

    return Visibility(
      visible: postType != PetTypeStrings.other,
      child: UnderlineInputDropdown(
        isInErrorState: !(postsController.post as Pet).breed.isNotEmptyNeighterNull() && !postsController.formIsValid,
        initialValue: (postsController.post as Pet).breed,
        onChanged: (breed) {
          postsController.updatePost(PetEnum.breed.name, breed);
        },
        labelText:
            '${postsController.post.type == PetTypeStrings.bird ? PostDetailsStrings.selectSpecie : PostDetailsStrings.selectBreed}',
        items: postType == PetTypeStrings.other ? [] : DummyData.breeds[postsController.post.type]!,
        fontSize: 12.0,
      ),
      replacement: Padding(
        padding: EdgeInsets.fromLTRB(3.0.w, 0.0.h, 3.0.w, 16.0.h),
        child: Obx(
          () => UnderlineInputText(
            initialValue: (postsController.post as Pet).breed,
            validator: Validators.verifyEmpty,
            onChanged: (exoticBreed) {
              postsController.updatePost(PetEnum.breed.name, exoticBreed);
            },
            labelText: PostDetailsStrings.describBreed,
            fontSizeLabelText: 12.0,
          ),
        ),
      ),
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
      fontSize: 12.0,
    );
  }

  Column _petAge(List<String> yearsList, List<String> monthsList) {
    return Column(
      children: [
        OneLineText(
          widgetAlignment: Alignment(-0.92, 1),
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          text: PostFlowStrings.age,
          fontSize: 12,
        ),
        Row(
          children: [
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: (postsController.post as Pet).ageYear.toString(),
                onChanged: (anos) {
                  postsController.updatePost(
                    PetEnum.ageYear.name,
                    int.parse(anos ?? '0'),
                  );
                },
                labelText: PostFlowStrings.years,
                fontSize: 12.0,
                items: yearsList,
              ),
            ),
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: (postsController.post as Pet).ageMonth.toString(),
                onChanged: (meses) {
                  postsController.updatePost(
                    PetEnum.ageMonth.name,
                    int.parse(meses ?? '0'),
                  );
                },
                labelText: PostFlowStrings.months,
                fontSize: 12.0,
                items: monthsList,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _spacer() => SizedBox(height: 16.0.h);
}
