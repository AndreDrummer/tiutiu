import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/cards/card_ad.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

class ReviewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Post post = postsController.post;

    return InkWell(
      onTap: () {
        postsController.reviewPost();
      },
      child: Container(
        child: CardAd(
          cardBuilder: CardBuilder(distanceText: '0.00', post: post),
          inReviewMode: true,
          post: post,
        ),
      ),
    );
  }
}
