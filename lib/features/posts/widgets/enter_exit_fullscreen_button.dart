import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class EnterExitFullScreenButton extends StatelessWidget {
  const EnterExitFullScreenButton({
    required this.icon,
    this.onTap,
    super.key,
  });

  final Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Icon(color: AppColors.white, size: 24.0.h, icon),
        padding: EdgeInsets.all(8.0.h),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          shape: BoxShape.circle,
        ),
      ),
      onTap: onTap,
    );
  }
}
