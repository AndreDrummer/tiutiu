import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onPressed,
    this.backgroundColor,
    this.fontWeight,
    this.textColor,
    this.fontSize,
    this.text,
    this.icon,
    super.key,
  });

  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Function()? onPressed;
  final Color? textColor;
  final double? fontSize;
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0.w),
      width: Get.width,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          disabledForegroundColor: Colors.grey,
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: hasIcon,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.height > 999 ? 6.0.w : 4.0.w,
                ),
                child: Icon(Icons.edit, size: 14.0.h),
              ),
            ),
            OneLineText(
              text: text ?? AppLocalizations.of(context)!.cancel,
              fontWeight: fontWeight ?? FontWeight.bold,
              widgetAlignment: Alignment.center,
              fontSize: fontSize ?? 16.0,
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
