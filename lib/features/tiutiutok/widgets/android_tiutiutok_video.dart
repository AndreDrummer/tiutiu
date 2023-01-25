import 'package:tiutiu/features/posts/model/post.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class AndroidTiutiuTokVideo extends StatefulWidget {
  const AndroidTiutiuTokVideo({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<AndroidTiutiuTokVideo> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AndroidTiutiuTokVideo> {
  late BetterPlayerController _betterController;
  Post get post => widget.post;

  @override
  void initState() {
    super.initState();

    _betterController = BetterPlayerController(
      BetterPlayerConfiguration(
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableFullscreen: false,
          enableSkips: false,
        ),
        aspectRatio: .5,
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
      betterPlayerPlaylistConfiguration: BetterPlayerPlaylistConfiguration(loopVideos: true),
    );
  }

  @override
  void dispose() {
    _betterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BetterPlayer(controller: _betterController);
}
