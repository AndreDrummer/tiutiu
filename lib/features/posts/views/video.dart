import 'package:tiutiu/features/posts/widgets/ad_video_item.dart';
import 'package:tiutiu/features/posts/widgets/video_player.dart';
import 'package:tiutiu/Widgets/animated_text_icon_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:video_player/video_player.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

final int VIDEO_SECS_LIMIT = 90;

class Video extends StatefulWidget with Pickers {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        _insertVideoLabel(),
        _video(),
        Spacer(),
        _videoErrorLabel(),
        _removeVideoButton(),
        Spacer(),
      ],
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
            final videoModel = VideoPlayerController.file(videoFile);

            videoModel.initialize().then((value) {
              videoModel.setVolume(0);
              videoModel.play();
              videoModel.pause();
              final videoDuration = videoModel.value.duration;
              if (videoDuration.inSeconds <= VIDEO_SECS_LIMIT) {
                postsController.updatePet(PetEnum.video, videoFile);
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
    return TiuTiuVideoPlayer(videoPath: postsController.post.video);
  }

  Widget _videoErrorLabel() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(bottom: 8.0.h),
        child: OneLineText(
          text: postsController.uploadingAdText,
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
            postsController.updatePet(PetEnum.video, null);
          },
        );
      },
    );
  }
}
