import 'package:tiutiu/Widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/features/system/controllers.dart';

class CardAdList extends StatelessWidget {
  const CardAdList({
    required this.post,
  });

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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0.h),
      ),
      height: 156.0.h,
      padding: EdgeInsets.zero,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.h),
        ),
        elevation: 8.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardBuilder.adImages(),
            Container(
              margin: EdgeInsets.only(left: 4.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7.0.h),
                            child: cardBuilder.adTitle(),
                          ),
                          cardBuilder.adDescription(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w, bottom: 4.0.h),
                        child: Visibility(
                          visible: authController.userExists,
                          child: cardBuilder.favoriteButton(),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  cardBuilder.adDistanceFromUser(),
                  cardBuilder.adViews(),
                  cardBuilder.adInteresteds(),
                  cardBuilder.adPostedAt(),
                  Spacer(),
                  cardBuilder.divider(),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0.h),
                    child: cardBuilder.adCityState(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
