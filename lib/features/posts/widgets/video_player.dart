import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/posts/widgets/video_fullscreen.dart';

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
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black.withAlpha(25)),
              borderRadius: BorderRadius.all(Radius.circular(16.0.h)),
              color: AppColors.black,
            ),
            margin: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
            child: Chewie(controller: chewieController),
            height: Get.height / 2.5,
          ),
          Positioned(
            right: isInReviewMode ? 32.0.w : 16.0.w,
            bottom: isInReviewMode ? 40.0.h : null,
            top: isInReviewMode ? null : 56.0.h,
            child: EnterExitFullScreenButton(
              onOpenFullscreen: () => openFullScreen(context),
            ),
          )
        ],
      ),
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
