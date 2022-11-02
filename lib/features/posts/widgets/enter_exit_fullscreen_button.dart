import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EnterExitFullScreenButton extends StatelessWidget {
  const EnterExitFullScreenButton({
    this.isFullscreen = false,
    this.onOpenFullscreen,
    super.key,
  });

  final Function()? onOpenFullscreen;
  final bool isFullscreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenFullscreen,
      child: Container(
        child: Icon(
          isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
          color: AppColors.white,
        ),
        padding: EdgeInsets.all(4.0.h),
        decoration: BoxDecoration(
          color: AppColors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
