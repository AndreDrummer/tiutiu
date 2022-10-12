import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
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
            OneLineText(
              text: PostFlowStrings.addDescription,
              alignment: Alignment(-0.92, 1),
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: TextArea(
                initialValue: postsController.pet.describedAdress,
                labelText: AppStrings.jotSomethingDown,
                maxLines: 4,
                onChanged: (description) {
                  postsController.updatePet(PetEnum.details, description);
                },
              ),
            ),
            _divider(),
            OneLineText(
              text: PostFlowStrings.otherCaracteristics,
              alignment: Alignment(-0.92, 1),
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
            SizedBox(
              height: Get.height,
              child: GridView.count(
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
                        value: false,
                        onChanged: (value) {},
                      ),
                    );
                  }).toList()),
            )
          ],
        ),
      ),
    );
  }

  Divider _divider() => Divider(color: AppColors.secondary);
}
