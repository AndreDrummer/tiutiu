import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EnterExitFullScreenButton extends StatelessWidget {
  const EnterExitFullScreenButton({
    this.isFullscreen = false,
    this.onTap,
    super.key,
  });

  final Function()? onTap;
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Icon(
          isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
          size: isFullscreen ? 56.0.h : 16.0.h,
          color: AppColors.white,
        ),
        padding: EdgeInsets.all(4.0.h),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
      ),
      onTap: onTap,
    );
  }
}
