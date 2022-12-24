import 'package:tiutiu/features/posts/widgets/ad_video_item.dart';
import 'package:tiutiu/features/posts/widgets/video_player.dart';
import 'package:tiutiu/core/widgets/animated_text_icon_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:video_player/video_player.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

final int VIDEO_SECS_LIMIT = 90;

class PostVideo extends StatefulWidget with Pickers {
  const PostVideo({super.key});

  @override
  State<PostVideo> createState() => _PostVideoVideoState();
}

class _PostVideoVideoState extends State<PostVideo> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    initializeChewiwController();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  void initializeChewiwController() {
    if (postsController.post.video != null) {
      postsController.chewieController = VideoUtils.instance.getChewieController(
        postsController.post.video,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (appController.properties.bottomSheetIsOpen) {
          Get.back();
          appController.bottomSheetIsOpen = false;
        }
      },
      child: Column(
        children: [
          Spacer(),
          _insertVideoLabel(),
          _video(),
          Spacer(),
          _videoErrorLabel(),
          _removeVideoButton(),
          Spacer(),
        ],
      ),
    );
  }

  Widget _insertVideoLabel() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: OneLineText(
        text: PostFlowStrings.insertVideo,
        widgetAlignment: Alignment.center,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _video() {
    return Obx(() {
      final videoPath = postsController.post.video;
      return videoPath == null ? _addVideo() : _playVideo();
    });
  }

  Widget _addVideo() {
    return Container(
      margin: EdgeInsets.only(right: 8.0.w, left: 4.0.w),
      child: AddVideoItem(
        hasError: false,
        onVideoPicked: (file) {
          if (file != null) {
            File videoFile = File(file.path);
            videoPlayerController = VideoPlayerController.file(videoFile);

            videoPlayerController!.initialize().then((value) {
              videoPlayerController!.setVolume(0);
              videoPlayerController!.play();
              videoPlayerController!.pause();
              final videoDuration = videoPlayerController!.value.duration;
              if (videoDuration.inSeconds <= VIDEO_SECS_LIMIT) {
                postsController.updatePost(PostEnum.video.name, videoFile);
                postsController.clearError();
              } else {
                debugPrint('Video Size Exceed ${videoDuration.inSeconds}');
                postsController.setError(PostFlowStrings.videoSizeExceed);
              }
            });
          }
        },
      ),
    );
  }

  Widget _playVideo() {
    initializeChewiwController();

    return TiuTiuVideoPlayer(
      chewieController: postsController.chewieController!,
      aspectRatio: Get.width / (Get.height / 3),
      isInReviewMode: true,
    );
  }

  Widget _videoErrorLabel() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(bottom: 8.0.h),
        child: OneLineText(
          text: postsController.flowErrorText,
          widgetAlignment: Alignment.center,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          color: AppColors.danger,
        ),
      ),
    );
  }

  Obx _removeVideoButton() {
    return Obx(
      () {
        return AnimatedTextIconButton(
          showCondition: postsController.post.video != null,
          textLabel: PostFlowStrings.removeVideo,
          elementsColor: AppColors.danger,
          icon: Icons.remove,
          onPressed: () {
            postsController.disposeVideoController();
            postsController.updatePost(PostEnum.video.name, null);
          },
        );
      },
    );
  }
}
