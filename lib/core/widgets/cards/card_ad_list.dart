import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
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
    return Stack(
      children: [
        Container(
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
                      cardBuilder.adViews(),
                      cardBuilder.adCityState(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cardBuilder.adPostedAt(),
                          SizedBox(width: 80.0.w),
                          cardBuilder.saveButton(show: showSaveButton),
                        ],
                      ),
                      Visibility(visible: !authController.userExists, child: SizedBox(height: 8.0.h)),
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
      ],
    );
  }

  Widget _tagIsDisappeared(bool visible) {
    return Visibility(
      visible: visible,
      child: Container(
        alignment: Alignment.center,
        height: 16.0.h,
        width: 64.0.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.0.h),
            bottomRight: Radius.circular(8.0.h),
            bottomLeft: Radius.circular(8.0.h),
          ),
          color: Colors.orange,
        ),
        child: AutoSizeTexts.autoSizeText(
          'PET Desaparecido',
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          fontSize: 8,
        ),
      ),
    );
  }
}
