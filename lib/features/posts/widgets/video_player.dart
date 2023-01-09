import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:tiutiu/features/posts/widgets/video_fullscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class TiuTiuVideoPlayer extends StatefulWidget {
  const TiuTiuVideoPlayer({
    required this.chewieController,
    this.isInReviewMode = false,
    required this.aspectRatio,
  });

  final ChewieController chewieController;
  final bool isInReviewMode;
  final double aspectRatio;

  @override
  State<TiuTiuVideoPlayer> createState() => _TiuTiuVideoPlayerState();
}

class _TiuTiuVideoPlayerState extends State<TiuTiuVideoPlayer> {
  bool isMuted = false;

  @override
  void initState() {
    isMuted = widget.chewieController.videoPlayerController.value.volume == 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.isInReviewMode
        ? BorderRadius.all(Radius.circular(16.0.h))
        : BorderRadius.only(
            topLeft: Radius.circular(16.0.h),
            topRight: Radius.circular(16.0.h),
          );

    return Stack(
      children: [
        Positioned(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black.withAlpha(25)),
              borderRadius: borderRadius,
              color: AppColors.black,
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Chewie(controller: widget.chewieController),
            ),
            height: Dimensions.getDimensBasedOnDeviceHeight(
              smaller: widget.isInReviewMode ? Get.height / 2.05 : Get.height / 1.5,
              medium: widget.isInReviewMode ? Get.height / 2.05 : Get.height,
              bigger: widget.isInReviewMode ? Get.height / 2.05 : Get.height,
            ),
            margin: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
          ),
        ),
        Positioned(
          bottom: 40.0.h,
          right: 16.0.w,
          child: EnterExitFullScreenButton(
            isMuted: isMuted,
            onOpenFullscreen: () => openFullScreen(context),
            onMuteOrUnMute: () {
              if (isMuted) {
                widget.chewieController.setVolume(100);

                setState(() {
                  isMuted = false;
                });
              } else {
                widget.chewieController.setVolume(0);

                setState(() {
                  isMuted = true;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  void openFullScreen(BuildContext context) {
    Get.to(
      () => VideoFullScreen(
        chewieController: widget.chewieController,
        isInReviewMode: widget.isInReviewMode,
      ),
    );
  }
}
