import 'package:tiutiu/features/favorites/widgets/post_is_saved_stream.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/loading_video.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostsVideos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final postsWithVideo = postsController.posts.where((post) => post.video != null).toList();

      return Padding(
        padding: EdgeInsets.only(bottom: 44.0.h),
        child: CarouselSlider.builder(
          itemCount: postsWithVideo.length,
          itemBuilder: (context, index, realIndex) {
            final post = postsWithVideo[index];

            return Stack(
              children: [
                _video(post),
                _viewsIcon(post.views),
                _likeButton(post.likes),
                _saveButton(post),
                _whatsAppShareButton(post.shared),
                _goToPostButton(post),
                _loadingBlur(),
              ],
            );
          },
          options: CarouselOptions(
            scrollDirection: Axis.vertical,
            autoPlayCurve: Curves.easeIn,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            disableCenter: true,
            viewportFraction: 1,
            autoPlay: false,
          ),
        ),
      );
    });
  }

  Widget _video(Post post) {
    return Positioned.fill(
      child: BetterPlayerListVideoPlayer(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          post.video,
          cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true),
        ),
        configuration: BetterPlayerConfiguration(
          controlsConfiguration: BetterPlayerControlsConfiguration(
            loadingWidget: LoadingVideo(),
            enableProgressText: false,
            enableFullscreen: false,
            enableSkips: false,
            enableMute: false,
          ),
          aspectRatio: .4,
          // autoPlay: true,
          // looping: true,
          errorBuilder: (context, errorMessage) {
            return VideoError(
              onRetry: () {},
            );
          },
          fit: BoxFit.cover,
        ),
        key: Key(post.uid.toString()),
        playFraction: 0.9,
        autoPlay: false,
      ),
    );
  }

  Widget _viewsIcon(int views) {
    return Positioned(
      bottom: 312.0.h,
      right: 20.0.h,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(FontAwesomeIcons.eye, size: 24.0.h, color: AppColors.whiteIce),
          ),
          _counterText(
            padding: EdgeInsets.only(left: 4.0.w, top: 2.0.h),
            text: '$views',
          ),
        ],
      ),
    );
  }

  Widget _likeButton(int likes) {
    return Positioned(
      bottom: 256.0.h,
      right: 18.0.h,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(FontAwesomeIcons.solidHeart, size: 24.0.h, color: AppColors.whiteIce),
            ),
            _counterText(
              padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
              text: '$likes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveButton(Post post) {
    return Positioned(
      bottom: 192.0.h,
      right: 18.0.h,
      child: PostIsSavedStream(
        post: post,
        builder: (icon, isActive) {
          return InkWell(
            onTap: () {
              savedsController.save(post);
            },
            child: Column(
              children: [
                Obx(
                  () => CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.bookmark, size: 28.0.h, color: isActive ? AppColors.white : AppColors.whiteIce),
                  ),
                ),
                _counterText(
                  padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                  text: '${post.saved}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _whatsAppShareButton(int timesSaved) {
    return Positioned(
      bottom: 128.0.h,
      right: 20.0.h,
      child: InkWell(
        onTap: () {
          postsController.sharePost();
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 14.0.h,
              backgroundColor: Colors.transparent,
              child: AssetHandle.getImage(
                ImageAssets.whatsappShare,
              ),
            ),
            _counterText(
              padding: EdgeInsets.only(right: 2.0.w, top: 8.0.h),
              text: '$timesSaved',
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterText({required EdgeInsetsGeometry padding, required String text}) {
    return Padding(
      padding: padding,
      child: AutoSizeTexts.autoSizeText14(
        text,
        color: AppColors.whiteIce,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _goToPostButton(Post post) {
    return Positioned(
      bottom: 72.0.h,
      right: 16.0.h,
      child: TextButton(
        onPressed: () {
          postsController.post = post;
          Get.toNamed(Routes.postDetails);
        },
        child: AutoSizeTexts.autoSizeText14(
          'Ir para post',
          color: AppColors.white,
        ),
      ),
    );
  }

  Obx _loadingBlur() {
    return Obx(
      () => LoadDarkScreen(
        message: postsController.uploadingPostText,
        visible: postsController.isLoading,
      ),
    );
  }
}
