import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/pets/widgets/back_to_start.dart';
import 'package:tiutiu/Widgets/cards/widgets/card_builder.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/cards/card_ad_list.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenderListItem extends StatelessWidget {
  const RenderListItem({
    this.showBackToStartButton = false,
    this.showFavoriteButton = false,
    required this.onNavigateToTop,
    required this.post,
  });

  final Function()? onNavigateToTop;
  final bool showBackToStartButton;
  final bool? showFavoriteButton;
  final Post post;

  @override
  Widget build(BuildContext context) {
    List<String> distanceText = OtherFunctions.distanceCalculate(
      post.latitude!,
      post.longitude!,
    );

    CardBuilder cardBuilder = CardBuilder(
      distanceText: distanceText[0],
      post: post,
    );

    if (showBackToStartButton)
      return BackToStart(
        onPressed: onNavigateToTop,
      );
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.toNamed(Routes.petDetails);
          postsController.post = post;
        },
        child: homeController.cardVisibilityKind == CardVisibilityKind.banner
            ? CardAdList(
                showFavoriteButton: showFavoriteButton ?? authController.userExists,
                cardBuilder: cardBuilder,
                post: post,
              )
            : CardAd(
                showFavoriteButton: showFavoriteButton ?? authController.userExists,
                cardBuilder: cardBuilder,
                post: post,
              ),
      ),
    );
  }
}
