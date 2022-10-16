import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final caracs = DummyData.otherCaracteristicsList;

    return Scaffold(
      body: Obx(
        () => ListView(
          children: [
            _descriptionLabel(),
            _descriptionInputText(),
            _divider(),
            _otherCaracteristicsLabel(),
            _otherCaracteristicsGrid(caracs)
          ],
        ),
      ),
    );
  }
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

OneLineText _descriptionLabel() {
  return OneLineText(
    text: PostFlowStrings.addDescription,
    alignment: Alignment(-0.92, 1),
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );
}

OneLineText _otherCaracteristicsLabel() {
  return OneLineText(
    text: PostFlowStrings.otherCaracteristics,
    alignment: Alignment(-0.92, 1),
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );
}

SizedBox _otherCaracteristicsGrid(List<String> caracs) {
  return SizedBox(
    height: 168.0.h,
    child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 18 / 3,
        crossAxisSpacing: 2.0.h,
        mainAxisSpacing: 8.0.h,
        crossAxisCount: 2,
        children: caracs.map((carac) {
          return SizedBox(
            height: 12.0.h,
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: AutoSizeText(
                style: TextStyles.fontSize(),
                maxFontSize: 14,
                carac,
              ),
              onChanged: (_) {
                postsController.updatePet(PetEnum.otherCaracteristics, carac);
              },
              value: postsController.post.otherCaracteristics.contains(carac),
            ),
          );
        }).toList()),
  );
}

Divider _divider() => Divider(color: AppColors.secondary);
