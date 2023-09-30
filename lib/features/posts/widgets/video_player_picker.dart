import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoPlayerPicker extends StatefulWidget {
  const VideoPlayerPicker({
    required this.videoPath,
    required this.type,
    super.key,
  });

  final BetterPlayerDataSourceType type;
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
      widget.type,
      widget.videoPath,
    );

    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: Get.height > 999 || (Dimensions.isSmallDevice() || Dimensions.isXSmallDevice()) ? 1.3 : 1.0,
        allowedScreenSleep: false,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          progressBarHandleColor: AppColors.primary,
          loadingColor: AppColors.primary,
          showControlsOnInitialize: false,
          enableOverflowMenu: false,
          enableProgressText: false,
          enableFullscreen: false,
          enableSkips: false,
          enableMute: false,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.white),
                SizedBox(height: 4.0.h),
                AutoSizeTexts.autoSizeText14(AppLocalizations.of(context)!.videoPlayerError, color: AppColors.white),
                SizedBox(height: 16.0.h),
                TextButton(
                  onPressed: () {
                    _betterPlayerController.retryDataSource();
                    setState(() {});
                  },
                  child: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context)!.tryAgain, color: AppColors.white),
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
