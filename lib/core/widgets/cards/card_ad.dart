import 'package:tiutiu/core/widgets/cards/widgets/disappeared_tag.dart';
import 'package:tiutiu/core/widgets/cards/widgets/mark_as_done.dart';
import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      child: Icon(FontAwesomeIcons.solidHeart,
          color: AppColors.white.withOpacity(.9), size: 72),
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

        likesController.like(widget.post);

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
                    xSmaller: widget.inReviewMode
                        ? Get.height / 2.4
                        : Get.height / 1.5,
                    smaller: widget.inReviewMode
                        ? Get.height / 2.5
                        : Get.height / 1.5,
                    medium: widget.inReviewMode
                        ? Get.height / 2.5
                        : Get.height / 1.5,
                    bigger: widget.inReviewMode
                        ? Get.height / 2.22
                        : Get.height / 1.5,
                  ),
                  child: widget.cardBuilder.adImages(),
                  width: double.infinity,
                ),
                Visibility(
                  visible: !widget.inReviewMode && widget.showSaveButton,
                  child: Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.white),
                      child: Padding(
                        padding: EdgeInsets.all(8.0.h),
                        child: widget.cardBuilder.saveButton(
                          show: !widget.inReviewMode && widget.showSaveButton,
                        ),
                      ),
                    ),
                    bottom: 32.0.h,
                    right: 8.0.w,
                  ),
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
                Positioned(
                  child: _markAsDone(),
                  bottom: 16.0.h,
                  right: 8.0.w,
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

  Widget _tagIsDisappeared(bool visible) =>
      Visibility(child: DisappearedTag(), visible: visible);

  Widget _markAsDone() {
    return Visibility(
      visible: postsController.isInMyPostsList,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 16.0.w, top: 12.0.h, right: 16.0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.h),
          color: AppColors.white,
        ),
        child: MarkAsDone(pet: (widget.post as Pet)),
      ),
    );
  }
}
