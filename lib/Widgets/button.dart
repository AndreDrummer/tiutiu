import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/constants/text_styles.dart';

class ButtonWide extends StatelessWidget {
  ButtonWide({
    this.isToExpand = false,
    this.rounded = true,
    this.textIconColor,
    this.action,
    this.color,
    this.icon,
    this.text,
  });

  final Color? textIconColor;
  final Function? action;
  final bool isToExpand;
  final IconData? icon;
  final bool? rounded;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;

    return GestureDetector(
      onTap: () => action?.call(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0.h),
        alignment: Alignment.center,
        height: 48.0.h,
        width: isToExpand ? Get.width : 260.0.w,
        decoration: BoxDecoration(
          borderRadius: rounded == true ? BorderRadius.circular(24.0.h) : null,
          color: color ?? AppColors.secondary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Row(
            mainAxisAlignment:
                hasIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Visibility(
                visible: hasIcon,
                child: Icon(
                  color: textIconColor ?? AppColors.white,
                  size: 20.0.h,
                  icon,
                ),
              ),
              Spacer(),
              AutoSizeText(
                text ?? AppStrings.getStarted,
                textAlign: TextAlign.center,
                style: TextStyles.fontSize16(
                  color: textIconColor ?? AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
