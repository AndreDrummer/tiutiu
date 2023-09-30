import 'package:tiutiu/core/widgets/button_wide_outlined.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:flutter/material.dart';

class RowButtonBar extends StatelessWidget {
  const RowButtonBar({
    this.buttonSecondaryColor,
    this.buttonPrimaryColor,
    this.onSecondaryPressed,
    this.isLoading = false,
    this.onPrimaryPressed,
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
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0.h),
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
                text: textPrimary ?? AppLocalizations.of(context)!.save,
                isLoading: isLoading,
                isToExpand: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
