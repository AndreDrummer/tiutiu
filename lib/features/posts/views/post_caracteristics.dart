import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostCaracteristics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final caracs = DummyData.otherCaracteristicsList;

    return Obx(
      () => ListView(
        padding: EdgeInsets.zero,
        children: [_otherCaracteristicsLabel(), _otherCaracteristicsGrid(caracs)],
      ),
    );
  }
}

OneLineText _otherCaracteristicsLabel() {
  return OneLineText(
    text: PostFlowStrings.otherCaracteristics,
    widgetAlignment: Alignment(-0.75, 1),
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );
}

SizedBox _otherCaracteristicsGrid(List<String> caracs) {
  return SizedBox(
    height: Get.height / 2,
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
            title: AutoSizeTexts.autoSizeText12(carac),
            onChanged: (_) {
              postsController.updatePost(PetEnum.otherCaracteristics.name, carac);
            },
            value: (postsController.post as Pet).otherCaracteristics.contains(carac),
          ),
        );
      }).toList(),
    ),
  );
}
