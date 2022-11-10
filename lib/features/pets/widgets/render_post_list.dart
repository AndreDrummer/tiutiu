import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:tiutiu/Widgets/cards/card_ad_list.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/pets/widgets/back_to_start.dart';
import 'package:tiutiu/features/system/controllers.dart';

class RenderListItem extends StatelessWidget {
  const RenderListItem({
    this.showBackToStartButton = false,
    required this.onNavigateToTop,
    required this.post,
  });

  final Function()? onNavigateToTop;
  final bool showBackToStartButton;
  final Post post;

  @override
  Widget build(BuildContext context) {
    if (showBackToStartButton)
      return BackToStart(
        onPressed: onNavigateToTop,
      );
    return Obx(
      () =>
          homeController.cardVisibilityKind == CardVisibilityKind.banner ? CardAdList(post: post) : CardAd(post: post),
    );
  }
}
