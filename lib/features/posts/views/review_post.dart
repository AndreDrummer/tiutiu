import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:flutter/material.dart';

class ReviewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inReviewMode = postsController.isInReviewMode;
    Pet pet = postsController.post;

    return InkWell(
      onTap: () {
        postsController.reviewPost();
      },
      child: Container(
        margin: EdgeInsets.only(top: 32.0.h),
        child: CardAd(
          inReviewMode: inReviewMode,
          pet: pet,
        ),
      ),
    );
  }
}
