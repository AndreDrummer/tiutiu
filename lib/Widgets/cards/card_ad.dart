import 'package:tiutiu/Widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAd extends StatelessWidget {
  CardAd({required this.post, this.inReviewMode = false});

  final bool inReviewMode;
  final Post post;

  @override
  Widget build(BuildContext context) {
    debugPrint(post.toString());

    List<String> distanceText = OtherFunctions.distanceCalculate(
      post.latitude!,
      post.longitude!,
    );

    CardBuilder cardBuilder = CardBuilder(
      distanceText: distanceText[0],
      inReviewMode: inReviewMode,
      post: post,
    );

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              cardBuilder.adImages(),
              Visibility(
                visible: !inReviewMode,
                child: Positioned(
                  child: cardBuilder.favoriteButton(),
                  bottom: 16.0.h,
                  right: 16.0.w,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8.0.h),
                bottomLeft: Radius.circular(8.0.h),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(8.0.h),
              child: Row(
                children: [
                  Container(
                    width: Get.width * .92,
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
                            cardBuilder.adDescription(),
                            Spacer(),
                            cardBuilder.adInteresteds(),
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
