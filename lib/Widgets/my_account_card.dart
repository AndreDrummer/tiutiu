import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAccountCard extends StatelessWidget {
  MyAccountCard({
    this.isToCenterText = false,
    this.isToExpand = false,
    this.onPressed,
    this.icon,
    this.text,
  });

  final Function()? onPressed;
  final bool? isToCenterText;
  final bool? isToExpand;
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0.h),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.h),
            ),
            padding: EdgeInsets.zero,
            elevation: 8.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Get.width / 3,
                  child: AutoSizeTexts.autoSizeText16(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    '$text',
                  ),
                ),
                Icon(
                  color: AppColors.secondary.withAlpha(104),
                  size: 24.0.h,
                  icon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
