import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DennounceButton extends StatelessWidget {
  const DennounceButton({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Icon(
            color: AppColors.warning,
            Icons.warning_amber,
            size: 16.0.h,
          ),
        ),
      ),
    );
  }
}
