import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AndroidTiutiuTokVideo extends StatefulWidget {
  const AndroidTiutiuTokVideo({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<AndroidTiutiuTokVideo> createState() => _AndroidTiutiuTokVideo();
}

class _AndroidTiutiuTokVideo extends State<AndroidTiutiuTokVideo> {
  late BetterPlayerController _betterController;
  Post get post => widget.post;

  @override
  void initState() {
    super.initState();

    _betterController = BetterPlayerController(
      BetterPlayerConfiguration(
        errorBuilder: (context, errorMessage) => VideoError(),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          progressBarHandleColor: AppColors.primary,
          loadingColor: AppColors.primary,
          showControlsOnInitialize: false,
          enableOverflowMenu: false,
          enableProgressText: false,
          enableFullscreen: false,
          enablePlayPause: false,
          enableSkips: false,
          enableMute: false,
        ),
        aspectRatio: getAspectRatio(),
        autoPlay: true,
        looping: true,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        post.video,
        cacheConfiguration: BetterPlayerCacheConfiguration(
          maxCacheFileSize: 10 * 1024 * 1024,
          maxCacheSize: 10 * 1024 * 1024,
          preCacheSize: 10 * 1024 * 1024,
          key: post.uid,
        ),
      ),
      betterPlayerPlaylistConfiguration:
          BetterPlayerPlaylistConfiguration(loopVideos: true),
    );
  }

  double getAspectRatio() {
    if (Get.height < 700) return .645;
    return .52;
  }

  @override
  void dispose() {
    _betterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: Get.height < 700 ? 36.0 : 0.0),
        child: BetterPlayer(controller: _betterController),
        color: AppColors.black,
      );
}
