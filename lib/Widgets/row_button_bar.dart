import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/button_wide_outlined.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:flutter/material.dart';

class RowButtonBar extends StatelessWidget {
  const RowButtonBar({
    this.buttonSecondaryColor,
    this.buttonPrimaryColor,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.textPrimary,
    this.textSecond,
    super.key,
  });

  final Function()? onPrimaryPressed;
  final Function()? onSecondaryPressed;
  final Color? buttonSecondaryColor;
  final Color? buttonPrimaryColor;
  final String? textPrimary;
  final String? textSecond;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0.h,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: OutlinedButtonWide(
                color: buttonSecondaryColor ?? AppColors.secondary,
                onPressed: () => onSecondaryPressed?.call(),
                text: textSecond,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: ButtonWide(
                color: buttonPrimaryColor ?? AppColors.primary,
                onPressed: () => onPrimaryPressed?.call(),
                text: textPrimary ?? AppStrings.save,
                isToExpand: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
