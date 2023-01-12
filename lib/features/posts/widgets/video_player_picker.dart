import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerPicker extends StatefulWidget {
  const VideoPlayerPicker({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<VideoPlayerPicker> createState() => _VideoPlayerPickerState();
}

class _VideoPlayerPickerState extends State<VideoPlayerPicker> {
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  @override
  void initState() {
    super.initState();

    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      widget.videoPath,
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        allowedScreenSleep: false,
        aspectRatio: 1,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.white),
                SizedBox(height: 4.0.h),
                AutoSizeTexts.autoSizeText14(PostDetailsStrings.videoPlayerError, color: AppColors.white),
                SizedBox(height: 16.0.h),
                TextButton(
                  onPressed: () {
                    _betterPlayerController.retryDataSource();
                    setState(() {});
                  },
                  child: AutoSizeTexts.autoSizeText12(AppStrings.tryAgain, color: AppColors.white),
                )
              ],
            ),
          );
        },
        expandToFill: true,
        fit: BoxFit.cover,
        autoPlay: false,
      ),
      betterPlayerDataSource: _betterPlayerDataSource,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AspectRatio(
        aspectRatio: _betterPlayerController.getAspectRatio() ?? 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0.h)),
          child: BetterPlayer(
            controller: _betterPlayerController,
          ),
        ),
      ),
    );
  }
}
