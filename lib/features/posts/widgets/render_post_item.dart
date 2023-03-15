import 'package:tiutiu/features/posts/controller/posts_controller.dart';
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
    this.showSaveButton = true,
    this.onNavigateToTop,
    required this.post,
    this.onItemTapped,
    super.key,
  });

  final Function()? onNavigateToTop;
  final bool showBackToStartButton;
  final Function()? onItemTapped;
  final bool showSaveButton;
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
        padding: EdgeInsets.only(bottom: 96.0.h, top: 4.0.h),
        child: Visibility(
          visible: postsController.posts.length >= 10,
          child: BackToStart(
            onPressed: onNavigateToTop,
          ),
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
        child: postsController.cardVisibilityKind == CardVisibilityKind.banner
            ? CardAdList(
                showSaveButton: showSaveButton && authController.userExists,
                isInReviewMode: postsController.isInReviewMode,
                key: Key(post.uid.toString()),
                cardBuilder: cardBuilder,
                post: post,
              )
            : CardAd(
                showSaveButton: showSaveButton && authController.userExists,
                cardBuilder: cardBuilder,
                post: post,
              ),
      ),
    );
  }
}
