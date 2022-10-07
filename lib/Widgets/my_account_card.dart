import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/text_styles.dart';

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
                  child: AutoSizeText(
                    '$text',
                    style: TextStyles.fontSize16(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: AppColors.secondary.withAlpha(104),
                  size: 24.0.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
