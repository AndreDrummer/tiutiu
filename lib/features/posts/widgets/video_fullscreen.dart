import 'package:tiutiu/features/posts/widgets/enter_exit_fullscreen_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen({super.key, required this.videoPath});

  final dynamic videoPath;

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
          Transform.scale(
            child: Chewie(
              controller: VideoUtils.instance.getChewieController(
                widget.videoPath,
              ),
            ),
            scaleX: 1.15,
            scaleY: 1.05,
          ),
          Positioned(
            left: 24.0.w,
            top: Platform.isAndroid ? 64.0.h : 16.0.h,
            child: EnterExitFullScreenButton(
              icon: Icons.fullscreen_exit,
              onTap: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    VideoUtils.instance.dispose();
    super.dispose();
  }
}
