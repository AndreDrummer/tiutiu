import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/cancel_button.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:flutter/material.dart';

class ColumnButtonBar extends StatelessWidget {
  const ColumnButtonBar({
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
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: ButtonWide(
              color: buttonPrimaryColor ?? AppColors.primary,
              text: textPrimary ?? AppStrings.save,
              onPressed: () => onPrimaryPressed?.call(),
              isToExpand: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: CancelButton(
              textColor: buttonSecondaryColor ?? AppColors.secondary,
              onCancel: () => onSecondaryPressed?.call(),
            ),
          ),
        ],
      ),
    );
  }
}
