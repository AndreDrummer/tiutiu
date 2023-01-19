import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class CardAd extends StatefulWidget {
  CardAd({
    this.showSaveButton = true,
    this.inReviewMode = false,
    required this.cardBuilder,
    required this.post,
  });

  final CardBuilder cardBuilder;
  final bool showSaveButton;
  final bool inReviewMode;
  final Post post;

  @override
  State<CardAd> createState() => _CardAdState();
}

class _CardAdState extends State<CardAd> {
  bool hasVideo() => widget.post.video != null;

  double likeAnimationOpcaity = 0;

  Widget likeAnimation() {
    return AnimatedOpacity(
      child: Icon(FontAwesomeIcons.solidHeart, color: AppColors.white.withOpacity(.8), size: 64),
      duration: Duration(milliseconds: 250),
      opacity: likeAnimationOpcaity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          likeAnimationOpcaity = 1;
        });

        savedsController.save(widget.post);

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            likeAnimationOpcaity = 0;
          });
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: Dimensions.getDimensBasedOnDeviceHeight(
                    xSmaller: widget.inReviewMode ? Get.height / 2.4 : Get.height / 1.5,
                    smaller: widget.inReviewMode ? Get.height / 2.2 : Get.height / 1.5,
                    medium: widget.inReviewMode ? Get.height / 2.22 : Get.height / 1.5,
                    bigger: widget.inReviewMode ? Get.height / 2.22 : Get.height / 1.5,
                  ),
                  child: widget.cardBuilder.adImages(),
                  width: double.infinity,
                ),
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                    child: widget.cardBuilder.saveButton(
                      show: !widget.inReviewMode && widget.showSaveButton,
                    ),
                  ),
                  bottom: 72.0.h,
                  right: 8.0.w,
                ),
                Positioned(
                  child: likeAnimation(),
                  bottom: Get.height / 3.5,
                  left: Get.width / 2.5,
                ),
                Positioned(
                  child: _tagIsDisappeared((widget.post as Pet).disappeared),
                  right: 0,
                  top: 0,
                ),
              ],
            ),
            Container(
              width: Get.width,
              child: Container(
                padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 2.5.h),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.cardBuilder.adTitle(),
                          widget.cardBuilder.adDistanceFromUser(),
                        ],
                      ),
                      Row(
                        children: [
                          widget.cardBuilder.adDescription(maxFontSize: 10),
                          Spacer(),
                          widget.cardBuilder.adViews(),
                        ],
                      ),
                      Row(
                        children: [
                          widget.cardBuilder.adPostedAt(),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: widget.cardBuilder.adCityState(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tagIsDisappeared(bool visible) {
    return Visibility(
      visible: visible,
      child: Container(
        height: 48.0.h,
        width: 64.0.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0.h),
            bottomLeft: Radius.circular(88.0.h),
          ),
          color: Colors.orange,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Transform.rotate(
            angle: pi / 4,
            child: AutoSizeTexts.autoSizeText10(
              PostDetailsStrings.petDisappeared,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
