import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/features/saveds/widgets/post_is_saved_stream.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:tiutiu/core/widgets/loading_video.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/widgets/video_error.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TiutiuTok extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late Post post;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Obx(() {
          final postsWithVideo = [];
          postsController.posts.where((post) => post.video != null).toList();

          if (postsWithVideo.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 96.0.h,
                  width: 96.0.h,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.h),
                    child: AssetHandle.getImage(ImageAssets.noTiutiutok),
                  ),
                ),
                SizedBox(height: 32.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: AutoSizeTexts.autoSizeText12('Nenhum ', color: AppColors.black),
                    ),
                    AutoSizeText('Tiutiu Tok', style: GoogleFonts.miltonianTattoo(color: AppColors.black)),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: AutoSizeTexts.autoSizeText12(' encontrado ', color: AppColors.black),
                    ),
                  ],
                )
              ],
            );
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 44.0.h),
            child: CarouselSlider.builder(
              itemCount: postsWithVideo.length,
              itemBuilder: (context, index, realIndex) {
                post = postsWithVideo[index];
                postsController.increasePostViews(post.uid);

                return Stack(
                  children: [
                    _video(post),
                    _buttons(post),
                    _postDetails(post),
                    _loadingBlur(),
                  ],
                );
              },
              options: CarouselOptions(
                onPageChanged: (index, reason) async {
                  if (!authController.userExists) {
                    await likesController.getLikesSavedOnDevice();
                  }
                },
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
        }),
      ),
    );
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
          autoPlay: true,
          looping: true,
          errorBuilder: (context, errorMessage) {
            return VideoError(
              onRetry: () {},
            );
          },
          fit: BoxFit.cover,
        ),
        key: Key(post.uid.toString()),
        playFraction: 0.9,
        autoPlay: true,
      ),
    );
  }

  Widget _postDetails(Post post) {
    return Positioned(
      bottom: 96.0.h,
      left: 16.0.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTexts.autoSizeText14(
            fontWeight: FontWeight.w700,
            color: AppColors.white,
            '${Formatters.cuttedText(post.name!)} | ${(post as Pet).city} - ${StatesAndCities.stateAndCities.getInitialFromStateName(post.state)}',
          ),
          SizedBox(height: 4.0.h),
          AutoSizeTexts.autoSizeText10(
            fontWeight: FontWeight.w400,
            color: AppColors.white,
            '${post.breed} - ${post.gender} - ${post.color}',
          ),
          SizedBox(height: 8.0.h),
          AutoSizeTexts.autoSizeText10(
            fontWeight: FontWeight.w400,
            color: AppColors.white,
            '${Formatters.cuttedText(OtherFunctions.replacePhoneNumberWithStars(post.description), size: 170)}',
          ),
        ],
      ),
    );
  }

  Widget _buttons(Post post) {
    return Positioned(
      bottom: 56.0.h,
      right: 0,
      child: Column(
        children: [
          _disappearedAlertAnimation(post),
          _viewsIcon(post),
          _likeButton(post),
          _saveButton(post),
          _whatsAppShareButton(post),
          _goToPostButton(post),
        ],
      ),
    );
  }

  Widget _disappearedAlertAnimation(Post post) {
    return Visibility(
      visible: (post as Pet).disappeared,
      child: Column(
        children: [
          LottieAnimation(
            animationPath: AnimationsAssets.disappearedAlert,
            size: 40.0.h,
          ),
          _counterText(
            padding: EdgeInsets.only(top: 2.0.h),
            fontSize: 10,
            text: 'PET\nDesaparecido',
          ),
          SizedBox(height: 8.0.h),
        ],
      ),
    );
  }

  Widget _viewsIcon(Post post) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(FontAwesomeIcons.eye, color: AppColors.whiteIce),
        ),
        StreamBuilder<int>(
          stream: postsController.postViews(post.uid!),
          builder: (context, snapshot) {
            int views = snapshot.data ?? post.likes;

            return _counterText(
              padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
              text: '$views',
            );
          },
        ),
        SizedBox(height: 8.0.h),
      ],
    );
  }

  Widget _likeButton(Post post) {
    return StreamBuilder<bool>(
      stream: likesController.postIsLiked(post),
      builder: (context, snapshot) {
        final liked = snapshot.data ?? false;

        return InkWell(
          onTap: () {
            likesController.like(post, wasLiked: liked);
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(FontAwesomeIcons.solidHeart, color: liked ? AppColors.pink : AppColors.whiteIce),
              ),
              StreamBuilder<int>(
                stream: likesController.postLikes(post.uid!),
                builder: (context, snapshot) {
                  int likesNumber = snapshot.data ?? post.likes;
                  likesNumber = likesNumber > 0 ? likesNumber : 0;

                  return _counterText(
                    padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                    text: '$likesNumber',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _saveButton(Post post) {
    return PostIsSavedStream(
      post: post,
      builder: (icon, isSaved) {
        return InkWell(
          onTap: () {
            if (authController.userExists) {
              savedsController.save(post, wasSaved: isSaved);
            } else {
              homeController.setMoreIndex();
            }
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.bookmark, size: 24.0.h, color: isSaved ? AppColors.white : AppColors.whiteIce),
              ),
              _counterText(
                padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                text: '${post.saved}',
              ),
              SizedBox(height: 16.0.h),
            ],
          ),
        );
      },
    );
  }

  Widget _whatsAppShareButton(Post post) {
    return InkWell(
      onTap: () {
        postsController.post = post;
        postsController.sharePost();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 12.0.h,
            backgroundColor: AppColors.primary,
            child: Center(child: Icon(FontAwesomeIcons.whatsapp, color: AppColors.white, size: 16.h)),
          ),
          StreamBuilder<int>(
            stream: postsController.postSharedTimes(post.uid!),
            builder: (context, snapshot) {
              int sharedTimesNumber = snapshot.data ?? post.likes;

              return _counterText(
                padding: EdgeInsets.only(right: 1.0.w, top: 5.0.h),
                text: '$sharedTimesNumber',
              );
            },
          ),
          SizedBox(height: 8.0.h),
        ],
      ),
    );
  }

  Widget _counterText({required EdgeInsetsGeometry padding, required String text, double fontSize = 14}) {
    return Padding(
      padding: padding,
      child: AutoSizeTexts.autoSizeText(
        textAlign: TextAlign.center,
        color: AppColors.whiteIce,
        fontSize: fontSize,
        text,
      ),
    );
  }

  Widget _goToPostButton(Post post) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.only(right: 16.0.w)),
      onPressed: () {
        postsController.post = post;
        Get.toNamed(Routes.postDetails);
      },
      child: AutoSizeTexts.autoSizeText14(
        'Ir para post',
        color: AppColors.white,
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
