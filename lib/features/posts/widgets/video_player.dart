import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:tiutiu/features/posts/widgets/video_fullscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class TiuTiuVideoPlayer extends StatefulWidget {
  const TiuTiuVideoPlayer({
    required this.videoPath,
  });

  final dynamic videoPath;

  @override
  State<TiuTiuVideoPlayer> createState() => _TiuTiuVideoPlayerState();
}

class _TiuTiuVideoPlayerState extends State<TiuTiuVideoPlayer> {
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
          margin: EdgeInsets.only(right: 8.0.w, left: 8.0.w),
          child: Chewie(
            controller: VideoUtils.instance.getChewieController(
              widget.videoPath,
            ),
          ),
          height: Get.height / 2.5,
        ),
        Positioned(
          right: 16.0.w,
          top: 16.0.h,
          child: EnterExitFullScreenButton(
            onTap: () => openFullScreen(),
            icon: Icons.fullscreen,
          ),
        )
      ],
    );
  }

  void openFullScreen() {
    Get.to(VideoFullScreen(videoPath: widget.videoPath));
  }

  @override
  void dispose() {
    VideoUtils.instance.dispose();
    super.dispose();
  }
}
