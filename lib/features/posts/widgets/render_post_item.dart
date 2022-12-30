import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:tiutiu/features/posts/widgets/back_to_start.dart';
import 'package:tiutiu/core/widgets/cards/card_ad_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/widgets/cards/card_ad.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenderListItem extends StatelessWidget {
  const RenderListItem({
    this.showBackToStartButton = false,
    this.showFavoriteButton = true,
    this.onNavigateToTop,
    this.onItemTapped,
    required this.post,
    super.key,
  });

  final Function()? onNavigateToTop;
  final bool showBackToStartButton;
  final Function()? onItemTapped;
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
      return Padding(
        padding: EdgeInsets.only(bottom: 56.0.h),
        child: BackToStart(
          onPressed: onNavigateToTop,
        ),
      );
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (onItemTapped != null) {
            onItemTapped?.call();
          } else {
            Get.toNamed(Routes.postDetails);
            postsController.post = post;
            postsController.increasePostViews();
          }
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
