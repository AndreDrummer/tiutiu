import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/Widgets/cards/card_ad.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/features/system/controllers.dart';

class ReviewPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pet pet = postsController.post;
    final inReviewMode = true;

    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.petDetails,
          arguments: inReviewMode,
        )?.then((_) {
          postsController.nextStep();
        });
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
