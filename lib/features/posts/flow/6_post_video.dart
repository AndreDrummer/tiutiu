import 'package:tiutiu/features/posts/widgets/video_player_picker.dart';
import 'package:tiutiu/core/widgets/animated_text_icon_button.dart';
import 'package:tiutiu/features/posts/widgets/ad_video_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:better_player/better_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

final int VIDEO_SECS_LIMIT = 90;

class PostVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        _insertVideoLabel(context),
        _video(context),
        Spacer(),
        _videoErrorLabel(),
        _removeVideoButton(context),
      ],
    );
  }

  Widget _insertVideoLabel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: OneLineText(
        text: AppLocalizations.of(context)!.insertVideo,
        widgetAlignment: Alignment.center,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _video(BuildContext context) {
    return Obx(() {
      final videoPath = postsController.post.video;
      return Container(
        margin: EdgeInsets.only(right: 8.0.w, left: 4.0.w),
        child: videoPath == null ? _addVideo(context) : _playVideo(),
      );
    });
  }

  Widget _addVideo(BuildContext context) {
    return AddVideoItem(
      hasError: postsController.flowErrorText.isNotEmpty,
      onVideoPicked: (file) {
        if (file != null) {
          File videoFile = File(file.path);
          VideoPlayerController videoPlayerController =
              VideoPlayerController.file(videoFile);

          videoPlayerController.initialize().then((value) {
            videoPlayerController.setVolume(0);
            videoPlayerController.play();
            videoPlayerController.pause();
            final videoDuration = videoPlayerController.value.duration;
            if (videoDuration.inSeconds <= VIDEO_SECS_LIMIT) {
              postsController.updatePost(PostEnum.video.name, videoFile);
              postsController.clearError();
            } else {
              if (kDebugMode)
                debugPrint(
                    'TiuTiuApp: Video Size Exceed ${videoDuration.inSeconds}');
              postsController
                  .setError(AppLocalizations.of(context)!.videoSizeExceed);
            }
            videoPlayerController.dispose();
          });
        }
      },
    );
  }

  Widget _playVideo() {
    final isFile = postsController.post.video is File;
    final videoUrl =
        isFile ? postsController.post.video.path : postsController.post.video;

    return VideoPlayerPicker(
      type: isFile
          ? BetterPlayerDataSourceType.file
          : BetterPlayerDataSourceType.network,
      videoPath: videoUrl,
    );
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

  Obx _removeVideoButton(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: EdgeInsets.only(top: 2.0.h),
          child: AnimatedTextIconButton(
            showCondition: postsController.post.video != null,
            textLabel: AppLocalizations.of(context)!.removeVideo,
            elementsColor: AppColors.danger,
            icon: Icons.remove,
            onPressed: () {
              postsController.updatePost(PostEnum.video.name, null);
            },
          ),
        );
      },
    );
  }
}
