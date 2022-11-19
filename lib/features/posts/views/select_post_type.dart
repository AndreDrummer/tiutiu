import 'package:tiutiu/features/posts/widgets/post_type_card_selector.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/flow/post_flow.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPostType extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    debugPrint('>> Post Type Screen Opened...');

    final filtersTypeText = filterController.filterTypeText.sublist(1).reversed.toList();

    final petsTypeImage = [
      StartScreenAssets.hamster,
      StartScreenAssets.cockatiel,
      StartScreenAssets.greyCat,
      StartScreenAssets.munkun,
    ];

    return WillPopScope(
      onWillPop: () async {
        if (postsController.isEditingPost) postsController.isEditingPost = false;
        return true;
      },
      child: Scaffold(
        appBar: DefaultBasicAppBar(text: postsController.isEditingPost ? PostFlowStrings.editAd : PostFlowStrings.post),
        body: Obx(
          () => Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.0.h),
                    _screenTitle(),
                    SizedBox(height: 8.0.h),
                    _gridView(filtersTypeText, petsTypeImage),
                    SizedBox(height: 24.0.h),
                    _isDisappearedBoxSelection(),
                    Spacer(),
                    _buttons(),
                  ],
                ),
              ),
              LoadDarkScreen(visible: postsController.isLoading)
            ],
          ),
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

  OneLineText _isThisPetDisappeared() {
    return OneLineText(
      text: PostFlowStrings.isThisPetDisappeared,
      widgetAlignment: Alignment(0.15, 1),
      fontSize: 24,
    );
  }

  Widget _isDisappearedBoxSelection() {
    return Obx(
      () => AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: postsController.post.type.isNotEmptyNeighterNull() ? 1 : 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _isThisPetDisappeared(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: AutoSizeTexts.autoSizeText12(AppStrings.yes),
                    onChanged: (_) {
                      postsController.updatePost(PetEnum.disappeared.name, true);
                    },
                    value: (postsController.post as Pet).disappeared,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: AutoSizeTexts.autoSizeText12(AppStrings.no),
                    onChanged: (_) {
                      postsController.updatePost(PetEnum.disappeared.name, false);
                    },
                    value: !(postsController.post as Pet).disappeared,
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
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
                  postsController.updatePost(PostEnum.type.name, type);
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
      () => AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: postsController.post.type.isNotEmptyNeighterNull() ? 1 : 0,
        child: RowButtonBar(
          onPrimaryPressed: () async {
            await _setLocation();
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
                Get.back();

                if (postsController.isEditingPost) {
                  postsController.isEditingPost = false;
                  Get.offAndToNamed(Routes.myPosts);
                } else {
                  homeController.setDonateIndex();
                }

                postsController.clearForm();
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

  Future<void> _setLocation() async {
    final hasAValidPlacemark = currentLocationController.hasAValidPlacemark();

    debugPrint('>> Placemark is valid $hasAValidPlacemark');

    if (!hasAValidPlacemark) {
      postsController.isLoading = true;
      await currentLocationController.setUserLocation();
      postsController.isLoading = false;
    }
  }
}
