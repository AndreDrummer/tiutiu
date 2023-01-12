import 'package:tiutiu/features/posts/widgets/video_player_picker.dart';
import 'package:tiutiu/core/widgets/animated_text_icon_button.dart';
import 'package:tiutiu/features/posts/widgets/ad_video_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/video_utils.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

final int VIDEO_SECS_LIMIT = 90;

class PostVideo extends StatelessWidget {
  void initializeChewiwController() {
    if (postsController.post.video != null) {
      postsController.chewieController = VideoUtils(post: postsController.post).getChewieController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (systemController.properties.bottomSheetIsOpen) {
          Get.back();
          systemController.bottomSheetIsOpen = false;
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
      return Container(
        margin: EdgeInsets.only(right: 8.0.w, left: 4.0.w),
        child: videoPath == null ? _addVideo() : _playVideo(),
      );
    });
  }

  Widget _addVideo() {
    return AddVideoItem(
      hasError: false,
      onVideoPicked: (file) {
        if (file != null) {
          File videoFile = File(file.path);
          VideoPlayerController videoPlayerController = VideoPlayerController.file(videoFile);

          videoPlayerController.initialize().then((value) {
            videoPlayerController.setVolume(0);
            videoPlayerController.play();
            videoPlayerController.pause();
            final videoDuration = videoPlayerController.value.duration;
            if (videoDuration.inSeconds <= VIDEO_SECS_LIMIT) {
              postsController.updatePost(PostEnum.video.name, videoFile.path);
              postsController.clearError();
            } else {
              debugPrint('TiuTiuApp: Video Size Exceed ${videoDuration.inSeconds}');
              postsController.setError(PostFlowStrings.videoSizeExceed);
            }
            videoPlayerController.dispose();
          });
        }
      },
    );
  }

  Widget _playVideo() {
    initializeChewiwController();

    return VideoPlayerPicker(videoPath: postsController.post.video);
  }

  Widget _videoErrorLabel() {
    return Obx(
      () => Visibility(
        visible: postsController.flowErrorText.isNotEmpty,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0.h),
          child: OneLineText(
            text: postsController.flowErrorText,
            widgetAlignment: Alignment.center,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            color: AppColors.danger,
          ),
        ),
      ),
    );
  }

  Obx _removeVideoButton() {
    return Obx(
      () {
        return Padding(
          padding: EdgeInsets.only(top: 2.0.h),
          child: AnimatedTextIconButton(
            showCondition: postsController.post.video != null,
            textLabel: PostFlowStrings.removeVideo,
            elementsColor: AppColors.danger,
            icon: Icons.remove,
            onPressed: () {
              postsController.disposeVideoController();
              postsController.updatePost(PostEnum.video.name, null);
            },
          ),
        );
      },
    );
  }
}
