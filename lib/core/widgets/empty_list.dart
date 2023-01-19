import 'package:tiutiu/features/home/controller/home_controller.dart';
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
    return Column(
      children: [
        Visibility(
          child: Container(
            child: LottieAnimation(animationPath: AnimationsAssets.catLookingAround),
            height: Get.width / 3,
          ),
          visible: isAPetScreenList,
        ),
        AutoSizeTexts.autoSizeText12(text ?? AppStrings.noPostFound),
        Visibility(
          visible: showClearFiltersButton,
          child: SimpleTextButton(
            text: AppStrings.cleanFilters,
            textColor: Colors.lightBlue,
            fontSize: 12,
            onPressed: () async {
              await postsController.getAllPosts();
              filterController.reset(homeController.bottomBarIndex == BottomBarIndex.FINDER.indx);
            },
          ),
        ),
      ],
    );
  }
}
