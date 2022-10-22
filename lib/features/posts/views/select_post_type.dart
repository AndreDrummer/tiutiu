import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/flow/post_flow.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/row_button_bar.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPostType extends StatelessWidget with TiuTiuPopUp {
  const SelectPostType({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('>> Post Type Screen Opened...');

    final filtersTypeText =
        filterController.filterTypeText.sublist(1).reversed.toList();

    final filtersIcon =
        filterController.filterTypeIcon.sublist(1).reversed.toList();

    return Scaffold(
      appBar: DefaultBasicAppBar(text: PostFlowStrings.post),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 8.0.h),
            OneLineText(
              text: PostFlowStrings.selectPetType,
              widgetAlignment: Alignment(-0.9, 1),
              fontSize: 24,
            ),
            Spacer(),
            Obx(
              () => GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 0.0.h,
                mainAxisSpacing: 0.0.h,
                childAspectRatio: 1,
                crossAxisCount: 2,
                shrinkWrap: true,
                children: filtersTypeText.map(
                  (type) {
                    final index = filtersTypeText.indexOf(type);
                    final selected = postsController.post.type == type;

                    return GestureDetector(
                      onTap: () {
                        postsController.updatePet(PetEnum.type, type);
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0.h),
                        height: 200.0.h,
                        width: 200.0.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0.h),
                          border: Border.all(
                            color: AppColors.secondary,
                            style: BorderStyle.solid,
                            width: 2.0.w,
                          ),
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color:
                              selected ? AppColors.white : AppColors.secondary,
                          shadowColor:
                              selected ? AppColors.secondary : AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0.h),
                          ),
                          elevation: selected ? 8.0 : 4.0,
                          child: Column(
                            children: [
                              SizedBox(height: 8.0.h),
                              SizedBox(
                                child: Icon(
                                  filtersIcon.elementAt(index),
                                  color: selected
                                      ? AppColors.secondary
                                      : AppColors.white,
                                  size: 80.0.h,
                                ),
                              ),
                              Spacer(),
                              AutoSizeText(
                                type,
                                style: TextStyles.fontSize24(
                                  color: selected
                                      ? AppColors.secondary
                                      : AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
            Spacer(),
            Obx(
              () => Visibility(
                visible: postsController.post.type.isNotEmptyNeighterNull(),
                child: RowButtonBar(
                  onPrimaryPressed: () {
                    Get.to(() => PostFlow());
                  },
                  onSecondaryPressed: () {
                    showPopUp(
                      message: PostFlowStrings.postCancelMessage,
                      title: PostFlowStrings.postCancelTitle,
                      mainAction: () => Get.back(),
                      confirmText: AppStrings.yes,
                      denyText: AppStrings.no,
                      secondaryAction: () {
                        postsController.previousStepFlow();
                        Get.back();
                      },
                      danger: true,
                    );
                  },
                  buttonSecondaryColor: AppColors.danger,
                  textPrimary: AppStrings.contines,
                  textSecond: AppStrings.cancel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
