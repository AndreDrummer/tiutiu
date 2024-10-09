import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/custom_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    this.isToCenterText = false,
    this.isToExpand = false,
    this.showBadge = false,
    this.onTap,
    this.badgeText,
    this.icon,
    this.text,
  });

  final Function()? onTap;
  final bool? isToCenterText;
  final String? badgeText;
  final bool? isToExpand;
  final bool showBadge;
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          width: Get.width,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.white,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              enableFeedback: false,
              elevation: 1.0,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.h),
              child: Row(
                children: [
                  Icon(color: AppColors.primaryDark, icon),
                  SizedBox(width: 16.0.w),
                  Container(child: AutoSizeTexts.autoSizeText12(color: AppColors.primaryDark, '$text')),
                  Spacer(),
                  Icon(color: AppColors.black.withAlpha(150), Icons.arrow_forward_ios, size: 12.0.h),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 40.0.w,
          top: 16.0.w,
          child: CustomBadge(
            color: AppColors.secondary,
            text: badgeText,
            show: showBadge,
          ),
        )
      ],
    );
  }
}
