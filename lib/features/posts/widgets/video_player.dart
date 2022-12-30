import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:tiutiu/features/posts/widgets/video_fullscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class TiuTiuVideoPlayer extends StatelessWidget {
  const TiuTiuVideoPlayer({
    required this.chewieController,
    this.isInReviewMode = false,
    required this.aspectRatio,
  });

  final ChewieController chewieController;
  final bool isInReviewMode;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black.withAlpha(25)),
            borderRadius: BorderRadius.all(Radius.circular(16.0.h)),
            color: AppColors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16.0.h)),
            child: Chewie(controller: chewieController),
          ),
          height: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: Get.height / 2.3,
            bigger: Get.height / 1.5,
            medium: Get.height / 2.1,
          ),
          margin: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
        ),
        Positioned(
          bottom: 40.0.h,
          right: 16.0.w,
          child: EnterExitFullScreenButton(
            onOpenFullscreen: () => openFullScreen(context),
          ),
        )
      ],
    );
  }

  void openFullScreen(BuildContext context) {
    Get.to(
      () => VideoFullScreen(
        chewieController: chewieController,
        isInReviewMode: isInReviewMode,
      ),
    );
  }
}
