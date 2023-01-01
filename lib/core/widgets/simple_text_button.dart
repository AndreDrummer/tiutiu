import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.text,
    this.icon,
    super.key,
  });

  final Function()? onPressed;
  final Color? backgroundColor;
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
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Icon(Icons.edit, size: 14.0.h),
              ),
            ),
            OneLineText(
              widgetAlignment: Alignment.center,
              text: text ?? AppStrings.cancel,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 16.0,
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
