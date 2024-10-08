import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          ImageCarouselBackground(),
          Container(color: AppColors.black.withOpacity(.5)),
          Container(
            width: double.infinity,
            height: Get.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetHandle.imageProvider(ImageAssets.follow),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: BackButton(
              color: AppColors.white,
            ),
            top: 32.0.h,
          ),
          Positioned(
            child: RatingUs(),
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
          )
        ],
      ),
    );
  }
}
