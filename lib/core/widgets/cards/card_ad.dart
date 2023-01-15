import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/cards/widgets/card_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardAd extends StatefulWidget {
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
  State<CardAd> createState() => _CardAdState();
}

class _CardAdState extends State<CardAd> {
  double favoriteAnimationOpcaity = 0;

  Widget favoritedAnimation() {
    return AnimatedOpacity(
      child: Icon(FontAwesomeIcons.solidHeart, color: AppColors.white.withOpacity(.8), size: 64),
      duration: Duration(milliseconds: 250),
      opacity: favoriteAnimationOpcaity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          favoriteAnimationOpcaity = 1;
        });

        favoritesController.addFavorite(widget.post);

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            favoriteAnimationOpcaity = 0;
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
                    medium: Get.height / 1.5,
                    bigger: Get.height / 1.5,
                  ),
                  child: widget.cardBuilder.adImages(),
                  width: double.infinity,
                ),
                Positioned(
                  child: _postTileInfo(),
                  bottom: 0.0.h,
                ),
                Positioned(
                  child: widget.cardBuilder.favoriteButton(!widget.inReviewMode && widget.showFavoriteButton),
                  bottom: 16.0.h,
                  left: Get.width / 2.5,
                ),
                Positioned(
                  child: favoritedAnimation(),
                  bottom: Get.height / 3.5,
                  left: Get.width / 2.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _postTileInfo() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(.3),
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
          ],
        ),
      ),
    );
  }
}
