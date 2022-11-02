import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen({
    required this.chewieController,
    this.isInReviewMode = false,
    super.key,
  });

  final ChewieController chewieController;
  final bool isInReviewMode;

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  void setLandscapeLeft() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> setPortraitUp() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (widget.isInReviewMode) widget.chewieController.pause();
  }

  @override
  void initState() {
    setLandscapeLeft();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await setPortraitUp();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Chewie(controller: widget.chewieController),
              Positioned(
                bottom: 112.0.h,
                right: 24.0.w,
                child: EnterExitFullScreenButton(
                  isFullscreen: true,
                  onOpenFullscreen: () {
                    setPortraitUp().then((value) => Navigator.of(context).pop());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
