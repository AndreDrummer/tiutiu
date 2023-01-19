import 'dart:io';

import 'package:tiutiu/core/widgets/loading_video.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({super.key, required this.post});

  final Post post;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BetterPlayerListVideoPlayer(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          widget.post.video,
          videoExtension: '.mp4',
          cacheConfiguration: BetterPlayerCacheConfiguration(useCache: Platform.isAndroid),
        ),
        configuration: BetterPlayerConfiguration(
          errorBuilder: (context, errorMessage) => VideoError(),
          controlsConfiguration: BetterPlayerControlsConfiguration(
            loadingWidget: LoadingVideo(),
            enableProgressText: false,
            enableFullscreen: false,
            enableSkips: false,
            enableMute: false,
          ),
          aspectRatio: .4,
          autoPlay: true,
          looping: true,
          fit: BoxFit.cover,
        ),
        key: Key(widget.post.uid.toString()),
        playFraction: 0.9,
        autoPlay: true,
      ),
    );
  }
}
