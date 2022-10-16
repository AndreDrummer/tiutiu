import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:tiutiu/features/posts/widgets/video_fullscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class TiuTiuVideoPlayer extends StatefulWidget {
  const TiuTiuVideoPlayer({required this.videoPath});

  final dynamic videoPath;

  @override
  State<TiuTiuVideoPlayer> createState() => _TiuTiuVideoPlayerState();
}

class _TiuTiuVideoPlayerState extends State<TiuTiuVideoPlayer> {
  late ChewieController chewieController;

  @override
  void initState() {
    chewieController =
        VideoUtils.instance.getChewieController(widget.videoPath);
    super.initState();
  }

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
          child: Chewie(controller: chewieController),
          height: Get.height / 2.5,
        ),
        Positioned(
          child: EnterExitFullScreenButton(onTap: () => openFullScreen()),
          bottom: 40.0.h,
          right: 32.0.w,
        )
      ],
    );
  }

  void openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoFullScreen(
          chewieController: chewieController,
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   chewieController.dispose();
  //   super.dispose();
  // }
}
