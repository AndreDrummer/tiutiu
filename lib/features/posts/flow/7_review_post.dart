import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:tiutiu/core/widgets/cards/card_ad_list.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/cards/card_ad.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Post post = postsController.post;
    CardBuilder cardBuilder = CardBuilder(distanceText: '0.00', post: post);

    return InkWell(
      onTap: () {
        postsController.reviewPost();
      },
      child: Container(
        child: Obx(
          () => Visibility(
            visible: homeController.cardVisibilityKind == CardVisibilityKind.card,
            child: CardAd(
              cardBuilder: cardBuilder,
              inReviewMode: true,
              post: post,
            ),
            replacement: CardAdList(
              cardBuilder: cardBuilder,
              showSaveButton: false,
              isInReviewMode: true,
              post: post,
              key: key,
            ),
          ),
        ),
      ),
    );
  }
}
