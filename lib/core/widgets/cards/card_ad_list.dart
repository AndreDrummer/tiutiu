import 'package:tiutiu/core/widgets/cards/widgets/disappeared_tag.dart';
import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:tiutiu/core/widgets/cards/widgets/mark_as_done.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAdList extends StatelessWidget {
  const CardAdList({
    required this.showSaveButton,
    required this.isInReviewMode,
    required this.cardBuilder,
    required this.post,
    required super.key,
  });

  final CardBuilder cardBuilder;
  final bool showSaveButton;
  final bool isInReviewMode;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0.h),
          ),
          height: Dimensions.getDimensBasedOnDeviceHeight(
            xSmaller: isInReviewMode ? 144.0.h : 160.0.h,
            smaller: isInReviewMode ? 144.0.h : 152.0.h,
            bigger: isInReviewMode ? 120.0.h : 124.0.h,
            medium: isInReviewMode ? 124.0.h : 128.0.h,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.0),
                          Container(
                            child: cardBuilder.adTitle(),
                            width: Get.width / 2.2,
                          ),
                          cardBuilder.adDescription(maxFontSize: 10),
                        ],
                      ),
                      cardBuilder.adViews(),
                      Spacer(),
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
        ),
        Positioned(
          child: _tagIsDisappeared((post as Pet).disappeared),
          right: 4.0.w,
          top: 3.5.h,
        ),
        Positioned(
          child: cardBuilder.saveButton(show: showSaveButton),
          bottom: 16.0.h,
          right: 16.0.w,
        ),
        Positioned(
          child: MarkAsDone(pet: (post as Pet)),
          bottom: 0.0.h,
          right: 8.0.w,
        ),
      ],
    );
  }

  Widget _tagIsDisappeared(bool visible) => Visibility(child: DisappearedTag(), visible: visible);
}
