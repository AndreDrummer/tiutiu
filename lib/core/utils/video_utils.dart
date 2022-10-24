import 'dart:io';

import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

class VideoUtils {
  VideoUtils._();

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  static VideoUtils get instance => VideoUtils._();

  ChewieController? getChewieController(
    dynamic videoPath, {
    bool isFullscreen = false,
    bool autoPlay = false,
  }) {
    if (videoPath != null) {
      if (videoPath.toString().isUrl()) {
        debugPrint('>> VideoPath from internet');
        videoPlayerController = VideoPlayerController.network(videoPath);
      } else {
        debugPrint('>> VideoPath from cache');
        videoPath is String ? videoPath = File(videoPath) : videoPath;
        videoPlayerController = VideoPlayerController.file(videoPath);
      }
      chewieController = ChewieController(
        placeholder: Center(child: CircularProgressIndicator()),
        aspectRatio: videoPlayerController?.value.aspectRatio,
        videoPlayerController: videoPlayerController!,
        showControlsOnInitialize: false,
        allowedScreenSleep: false,
        allowFullScreen: false,
        autoInitialize: true,
        autoPlay: autoPlay,
        zoomAndPan: true,
      );

      return chewieController;
    }

    return null;
  }
}
