import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/loading_video.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsVideos extends StatefulWidget {
  const PostsVideos({super.key});

  @override
  State<PostsVideos> createState() => _PostsVideosState();
}

class _PostsVideosState extends State<PostsVideos> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final postsWithVideo = postsController.posts.where((post) => post.video != null).toList();

      return CarouselSlider.builder(
        itemCount: postsWithVideo.length,
        itemBuilder: (context, index, realIndex) {
          final post = postsWithVideo[index];
          return BetterPlayerListVideoPlayer(
            BetterPlayerDataSource(
              BetterPlayerDataSourceType.network,
              post.video,
              cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true),
            ),
            configuration: BetterPlayerConfiguration(
              controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
              placeholder: LoadingVideo(),
              aspectRatio: .4,
              autoPlay: true,
              looping: true,
              errorBuilder: (context, errorMessage) {
                return VideoError(
                  onRetry: () {
                    setState(() {});
                  },
                );
              },
              fit: BoxFit.cover,
            ),
            key: Key(post.uid.toString()),
            playFraction: 0.9,
          );
        },
        options: CarouselOptions(
          scrollDirection: Axis.vertical,
          autoPlayCurve: Curves.easeIn,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: 1,
          autoPlay: false,
        ),
      );
    });
  }
}
