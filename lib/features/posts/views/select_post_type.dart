import 'package:tiutiu/features/posts/widgets/post_type_card_selector.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/flow/post_flow.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/row_button_bar.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPostType extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    debugPrint('>> Post Type Screen Opened...');

    final filtersTypeText =
        filterController.filterTypeText.sublist(1).reversed.toList();

    final petsTypeImage = [
      StartScreenAssets.hamster,
      StartScreenAssets.cockatiel,
      StartScreenAssets.greyCat,
      StartScreenAssets.munkun,
    ];

    return Scaffold(
      appBar: DefaultBasicAppBar(text: PostFlowStrings.post),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Column(
          children: [
            Spacer(),
            _screenTitle(),
            _gridView(filtersTypeText, petsTypeImage),
            Spacer(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  OneLineText _screenTitle() {
    return OneLineText(
      text: PostFlowStrings.selectPetType,
      widgetAlignment: Alignment(-0.9, 1),
      fontSize: 24,
    );
  }

  Obx _gridView(List<String> filtersTypeText, List<String> petsTypeImage) {
    return Obx(
      () {
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 0.0.h,
          mainAxisSpacing: 0.0.h,
          childAspectRatio: 1,
          crossAxisCount: 2,
          shrinkWrap: true,
          children: filtersTypeText.map(
            (type) {
              final index = filtersTypeText.indexOf(type);

              return PostTypeCardSelector(
                onTypeSelected: () {
                  postsController.updatePost(PetEnum.type, type);
                },
                isSelected: postsController.post.type == type,
                image: petsTypeImage.elementAt(index),
                typeText: type,
              );
            },
          ).toList(),
        );
      },
    );
  }

  Obx _buttons() {
    return Obx(
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
                postsController.clearForm();
                Get.back();
                homeController.bottomBarIndex = 0;
              },
              danger: true,
            );
          },
          buttonSecondaryColor: AppColors.danger,
          textPrimary: AppStrings.contines,
          textSecond: AppStrings.cancel,
        ),
      ),
    );
  }
}
