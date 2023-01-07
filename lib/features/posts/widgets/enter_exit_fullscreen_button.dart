import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EnterExitFullScreenButton extends StatelessWidget {
  const EnterExitFullScreenButton({
    this.isFullscreen = false,
    this.onOpenFullscreen,
    this.isMuted = false,
    this.onMuteOrUnMute,
    super.key,
  });

  final Function()? onOpenFullscreen;
  final Function()? onMuteOrUnMute;
  final bool isFullscreen;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isMuted ? Icons.volume_off_sharp : Icons.volume_up_sharp,
            size: isFullscreen ? 48.0.h : 22.0.h,
            color: AppColors.white,
          ),
          onPressed: onMuteOrUnMute,
        ),
        IconButton(
          icon: Icon(
            isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
            size: isFullscreen ? 48.0.h : 22.0.h,
            color: AppColors.white,
          ),
          padding: EdgeInsets.all(4.0.h),
          onPressed: onOpenFullscreen,
        ),
      ],
    );
  }
}
