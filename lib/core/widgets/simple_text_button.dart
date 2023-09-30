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

    return SizedBox(
      width: 16.0 * (text != null ? text!.length : 5),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.white,
          disabledForegroundColor: Colors.grey,
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: hasIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Visibility(
              visible: hasIcon,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height > 999 ? 6.0.w : 20.0.w),
                child: Icon(Icons.edit, size: 14.0.h),
              ),
            ),
            OneLineText(
              fontWeight: fontWeight ?? FontWeight.bold,
              widgetAlignment: Alignment.center,
              text: text ?? AppLocalizations.of(context)!.cancel,
              fontSize: fontSize ?? 16.0,
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
