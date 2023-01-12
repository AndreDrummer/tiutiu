import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAd extends StatelessWidget {
  CardAd({
    this.showFavoriteButton = true,
    this.inReviewMode = false,
    required this.cardBuilder,
    required this.post,
  });

  final CardBuilder cardBuilder;
  final bool showFavoriteButton;
  final bool inReviewMode;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: Dimensions.getDimensBasedOnDeviceHeight(
                  xSmaller: inReviewMode ? Get.height / 2.4 : Get.height / 2.0,
                  smaller: inReviewMode ? Get.height / 2.2 : Get.height / 2.0,
                  medium: Get.height / 2.0,
                  bigger: Get.height / 2.0,
                ),
                child: cardBuilder.adImages(),
                width: double.infinity,
              ),
              Positioned(
                child: cardBuilder.favoriteButton(!inReviewMode && showFavoriteButton),
                bottom: 16.0.h,
                right: 8.0.w,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0.h),
                topLeft: Radius.circular(8.0.h),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 8.0.h, left: 8.0.w),
              child: Row(
                children: [
                  Container(
                    width: Get.width * .91,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cardBuilder.adTitle(),
                            cardBuilder.adDistanceFromUser(),
                          ],
                        ),
                        Row(
                          children: [
                            cardBuilder.adDescription(maxFontSize: 10),
                            Spacer(),
                            cardBuilder.adViews(),
                          ],
                        ),
                        Row(
                          children: [
                            cardBuilder.adPostedAt(),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0.h),
                              child: cardBuilder.adCityState(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
