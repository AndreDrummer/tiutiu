import 'package:tiutiu/core/widgets/video_placeholder.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class IOSTiutiuTokVideo extends StatefulWidget {
  const IOSTiutiuTokVideo({super.key, required this.post});

  final Post post;

  @override
  State<IOSTiutiuTokVideo> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<IOSTiutiuTokVideo> {
  @override
  Widget build(BuildContext context) {
    return BetterPlayerListVideoPlayer(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.post.video,
        videoExtension: '.mp4',
        cacheConfiguration: BetterPlayerCacheConfiguration(useCache: Platform.isAndroid),
      ),
      configuration: BetterPlayerConfiguration(
        errorBuilder: (context, errorMessage) => VideoError(),
        placeholder: VideoPlaceholder(),
        controlsConfiguration: BetterPlayerControlsConfiguration(
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
    );
  }
}
