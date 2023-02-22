import 'package:tiutiu/features/posts/widgets/select_post_type_grid_view.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/features/posts/flow/post_flow.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ScrollController _pageScroll = ScrollController();

class SelectPostType extends StatelessWidget with TiuTiuPopUp {
  final screenAnimationDuration = Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) debugPrint('TiuTiuApp: Post Type Screen Opened...');

    return WillPopScope(
      onWillPop: () async {
        if (!postsController.isInReviewMode) postsController.clearForm();
        if (postsController.isEditingPost) postsController.isEditingPost = false;
        return true;
      },
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              appBar: DefaultBasicAppBar(
                  text: postsController.isEditingPost
                      ? AppLocalizations.of(context).editAd
                      : AppLocalizations.of(context).post),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                  child: ListView(
                    controller: _pageScroll,
                    children: [
                      _selectPostType(context),
                      _isDisappearedSelection(context),
                      _reward(context),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: Get.height < 700 ? 48.0.h : 40.h),
                child: _buttons(context),
              ),
            ),
            LoadDarkScreen(visible: postsController.isLoading)
          ],
        ),
      ),
    );
  }

  AnimatedContainer _selectPostType(BuildContext context) {
    double marginTop = postsController.post.type.isNotEmptyNeighterNull() ? 10 : Get.width / 3;
    final filtersTypeText = filterController.filterTypeText.sublist(1).reversed.toList();

    final petsTypeImage = [
      ImageAssets.questionMark,
      StartScreenAssets.cockatiel,
      StartScreenAssets.greyCat,
      StartScreenAssets.munkun,
    ];

    return AnimatedContainer(
      margin: EdgeInsets.only(top: marginTop),
      duration: screenAnimationDuration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _selectPostTypeTitle(context),
          SizedBox(height: 16.0.h),
          _gridView(filtersTypeText, petsTypeImage),
        ],
      ),
    );
  }

  OneLineText _selectPostTypeTitle(BuildContext context) {
    return OneLineText(
      text: AppLocalizations.of(context).selectPetType,
      fontSize: Get.height > 700 ? 24.0 : 16.0,
      widgetAlignment: Alignment(-0.9, 1),
    );
  }

  Widget _gridView(List<String> filtersTypeText, List<String> petsTypeImage) {
    return Obx(() {
      return SelectPostTypeGridView(
        onTypeSelected: (typeSelected) {
          postsController.updatePost(PostEnum.type.name, typeSelected);
          postsController.updatePost(PetEnum.color.name, '-');

          if (typeSelected == AppLocalizations.of(Get.context!).other) {
            postsController.updatePost(PetEnum.breed.name, '');
          } else {
            postsController.updatePost(PetEnum.breed.name, '-');
          }
        },
        pairRowAxisAlignment: MainAxisAlignment.start,
        petsTypeSelected: postsController.post.type,
        oddRowAxisAlignment: MainAxisAlignment.end,
        collsNumber: (filtersTypeText.length ~/ 2),
        rowsNumber: (filtersTypeText.length ~/ 2),
        filtersTypeText: filtersTypeText,
        petsTypeImage: petsTypeImage,
      );
    });
  }

  Widget _isDisappearedSelection(BuildContext context) {
    return Obx(
      () {
        double marginTop = (postsController.post as Pet).disappeared ? 16.0.h : 48.0.h;
        return AnimatedOpacity(
          duration: screenAnimationDuration,
          opacity: postsController.post.type.isNotEmptyNeighterNull() ? 1 : 0,
          child: AnimatedContainer(
            margin: EdgeInsets.only(top: marginTop),
            duration: screenAnimationDuration,
            child: Column(
              children: [
                _isDisappearedSelectionTitle(context),
                Row(
                  children: [
                    SizedBox(width: 4.0.w),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).yes),
                        onChanged: (_) {
                          postsController.updatePost(PetEnum.disappeared.name, true);
                          _pageScroll.animateTo(
                            duration: screenAnimationDuration,
                            curve: Curves.ease,
                            80.0.h,
                          );
                        },
                        value: (postsController.post as Pet).disappeared,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).no),
                        onChanged: (_) {
                          FocusScope.of(context).unfocus();
                          postsController.updatePost(PetEnum.disappeared.name, false);
                          postsController.updatePost(PetEnum.reward.name, '');
                          _pageScroll.animateTo(
                            duration: screenAnimationDuration,
                            curve: Curves.ease,
                            0.0.h,
                          );
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
      },
    );
  }

  OneLineText _isDisappearedSelectionTitle(BuildContext context) {
    return OneLineText(
      text: AppLocalizations.of(context).isThisPetDisappeared,
      widgetAlignment: Alignment(-0.88, 1),
      fontSize: 16,
    );
  }

  Widget _reward(BuildContext context) {
    return Obx(() {
      double marginBottom = (postsController.post as Pet).disappeared ? Get.height : 0.0.h;
      double marginTop = (postsController.post as Pet).disappeared ? 10 : Get.width / 3;

      return AnimatedOpacity(
        opacity: (postsController.post as Pet).disappeared ? 1 : 0,
        duration: screenAnimationDuration,
        child: AnimatedContainer(
          margin: EdgeInsets.only(top: marginTop, left: 8.0.w, right: 8.0.w, bottom: marginBottom),
          duration: screenAnimationDuration,
          child: Column(
            children: [
              _rewardTitle(context),
              TextArea(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: (postsController.post as Pet).reward,
                onChanged: (value) {
                  postsController.updatePost(PetEnum.reward.name, value);
                },
                labelText: '\$ 1.000',
                hintText: '1.000',
                prefix: '\$ ',
                maxLines: 1,
              ),
            ],
          ),
        ),
      );
    });
  }

  OneLineText _rewardTitle(BuildContext context) {
    return OneLineText(
      text: AppLocalizations.of(context).reward,
      widgetAlignment: Alignment(-0.99, 1),
      fontSize: 16,
    );
  }

  Obx _buttons(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        duration: screenAnimationDuration,
        opacity: postsController.post.type.isNotEmptyNeighterNull() ? 1 : 0,
        child: RowButtonBar(
          onPrimaryPressed: () async {
            await _setLocation();
            if (currentLocationController.permissionStatus == PermissionStatus.granted) Get.to(() => PostFlow());
          },
          onSecondaryPressed: postsController.showsCancelPostPopUp,
          buttonSecondaryColor: AppColors.danger,
          textPrimary: AppLocalizations.of(context).contines,
          textSecond: AppLocalizations.of(context).cancel,
        ),
      ),
    );
  }

  Future<void> _setLocation() async {
    postsController.isLoading = true;
    await currentLocationController.checkPermission();
    await currentLocationController.setUserLocation();
    postsController.isLoading = false;
  }
}
