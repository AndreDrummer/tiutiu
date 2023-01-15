import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({
    this.showClearFiltersButton = true,
    this.isAPetScreenList = true,
    this.text,
  });

  final bool showClearFiltersButton;
  final bool isAPetScreenList;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final filterParams = filterController.getParams;

        final filterParamsIsExotic = filterParams.type == PetTypeStrings.exotic;

        final animationEmpty = getAnimationBasedonFilter(filterParams);

        return Column(
          children: [
            Visibility(
              child: Container(
                child: Image.asset(ImageAssets.notFoundET),
                height: Get.width / 3,
              ),
              visible: isAPetScreenList && filterParamsIsExotic,
            ),
            Visibility(
              child: Container(
                child: LottieAnimation(animationPath: animationEmpty),
                height: Get.width / 3,
              ),
              visible: isAPetScreenList && !filterParamsIsExotic,
            ),
            AutoSizeTexts.autoSizeText12(text ?? AppStrings.noPostFound),
            Visibility(
              visible: showClearFiltersButton,
              child: SimpleTextButton(
                text: AppStrings.cleanFilters,
                textColor: Colors.lightBlue,
                fontSize: 12,
                onPressed: () {
                  filterController.reset(homeController.bottomBarIndex == 1);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String getAnimationBasedonFilter(FilterParams filterParams) {
    return filterParams.type == PetTypeStrings.bird
        ? AnimationsAssets.birdLoading
        : filterParams.type == PetTypeStrings.dog
            ? AnimationsAssets.dogWalking
            : filterParams.type == PetTypeStrings.all
                ? AnimationsAssets.dogLoading
                : filterParams.type == PetTypeStrings.exotic
                    ? AnimationsAssets.catLookingAround
                    : AnimationsAssets.catLoading;
  }
}
