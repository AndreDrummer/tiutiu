import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            child: Container(
              child: LottieAnimation(animationPath: AnimationsAssets.catLookingAround),
              height: Get.height > 999 ? Get.width / 4 : Get.width / 3,
            ),
            visible: isAPetScreenList,
          ),
          AutoSizeTexts.autoSizeText12(text ?? AppLocalizations.of(context)!.noPostFound),
          Visibility(
            visible: showClearFiltersButton,
            child: IconButton(
              icon: Icon(Icons.refresh),
              color: Colors.lightBlue,
              onPressed: () async {
                await postsController.getAllPosts();
                filterController.reset(homeController.bottomBarIndex == BottomBarIndex.FINDER.indx);
              },
            ),
          ),
        ],
      ),
    );
  }
}
