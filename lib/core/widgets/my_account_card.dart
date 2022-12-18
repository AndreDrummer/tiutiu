import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreCardOption extends StatelessWidget {
  MoreCardOption({
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
        padding: EdgeInsets.symmetric(vertical: 2.0.h),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8.0.h),
                bottomLeft: Radius.circular(8.0.h),
              ),
            ),
            padding: EdgeInsets.zero,
            elevation: 2.0,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: AutoSizeTexts.autoSizeText14(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    '$text',
                  ),
                  width: Get.width / 2.5,
                ),
                Icon(color: AppColors.secondary.withOpacity(.5), icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
