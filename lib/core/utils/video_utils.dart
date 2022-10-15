import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VideoUtils {
  VideoUtils._();

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  static VideoUtils get instance => VideoUtils._();

  ChewieController getChewieController(dynamic videoPath) {
    if (videoPath != null) {
      if (videoPath.toString().isUrl()) {
        videoPlayerController = VideoPlayerController.network(videoPath);
      } else {
        videoPlayerController = VideoPlayerController.file(videoPath);
      }
    }

    chewieController = ChewieController(
      placeholder: Center(child: CircularProgressIndicator()),
      videoPlayerController: videoPlayerController,
      showControlsOnInitialize: false,
      allowedScreenSleep: false,
      allowFullScreen: false,
      autoInitialize: false,
      zoomAndPan: false,
      autoPlay: true,
      looping: false,
    );

    return chewieController;
  }

  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
  }
}
