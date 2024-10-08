import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdImages extends StatelessWidget {
  const AdImages({
    required this.photos,
    super.key,
  });

  final List photos;

  @override
  Widget build(BuildContext context) {
    return postsController.cardVisibilityKind == CardVisibilityKind.card ? _cardAdImage() : _cardAdListImage();
  }

  Widget _cardAdImage() {
    final borderRadius = BorderRadius.only(
      topRight: Radius.circular(8),
      topLeft: Radius.circular(8),
    );

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0.h),
          topLeft: Radius.circular(8.0.h),
        ),
      ),
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: photos.length,
        itemBuilder: (ctx, index, i) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              width: double.infinity,
              color: AppColors.white,
              child: AssetHandle.getImage(
                photos.elementAt(index),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: photos.length > 1,
          autoPlayCurve: Curves.easeIn,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: 1,
          autoPlay: true,
        ),
      ),
    );
  }

  Widget _cardAdListImage() {
    final borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(8.0.h),
      topLeft: Radius.circular(8.0.h),
    );

    return Container(
      margin: EdgeInsets.only(right: 8.0.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0.h),
          topLeft: Radius.circular(8.0.h),
        ),
      ),
      child: CarouselSlider.builder(
        itemCount: photos.length,
        itemBuilder: (ctx, index, i) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: borderRadius,
            ),
            child: AssetHandle.getImage(photos.elementAt(index), borderRadius: borderRadius),
            width: double.infinity,
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: photos.length > 1,
          autoPlayCurve: Curves.easeIn,
          disableCenter: true,
          viewportFraction: 1,
          autoPlay: true,
        ),
      ),
      height: Get.width * .38,
      width: Get.width * .35,
    );
  }
}
