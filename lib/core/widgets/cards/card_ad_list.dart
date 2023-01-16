import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAdList extends StatelessWidget {
  const CardAdList({
    required this.showSaveButton,
    required this.cardBuilder,
    required this.post,
    required super.key,
  });

  final CardBuilder cardBuilder;
  final bool showSaveButton;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0.h),
      ),
      height: Dimensions.getDimensBasedOnDeviceHeight(
        xSmaller: 152.0.h,
        smaller: 144.0.h,
        bigger: 124.0.h,
        medium: 128.0.h,
      ),
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
              margin: EdgeInsets.only(left: 2.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: cardBuilder.adTitle(),
                            width: Get.width / 2.2,
                          ),
                          cardBuilder.adDescription(maxFontSize: 10),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0.w, bottom: 4.0.h, top: 4.0.h),
                        child: cardBuilder.saveButton(show: showSaveButton),
                      ),
                    ],
                  ),
                  cardBuilder.adViews(),
                  SizedBox(height: 6.0.h),
                  cardBuilder.adCityState(),
                  Divider(),
                  cardBuilder.adPostedAt(),
                  cardBuilder.adDistanceFromUser(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
