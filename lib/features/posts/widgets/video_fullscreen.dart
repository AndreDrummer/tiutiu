import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen({super.key, required this.chewieController});

  final ChewieController chewieController;

  @override
  State<VideoFullScreen> createState() => VideoFullScreenState();
}

class VideoFullScreenState extends State<VideoFullScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Chewie(controller: widget.chewieController),
          Positioned(
            left: 24.0.w,
            top: Platform.isAndroid ? 64.0.h : 16.0.h,
            child: EnterExitFullScreenButton(
              isFullscreen: true,
              onTap: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                widget.chewieController.videoPlayerController.pause();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
