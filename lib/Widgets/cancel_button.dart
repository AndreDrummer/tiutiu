import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';

class SimpleTextButton extends StatelessWidget {
  const SimpleTextButton({
    required this.onPressed,
    this.textColor,
    this.fontSize,
    this.text,
    super.key,
  });

  final Function()? onPressed;
  final Color? textColor;
  final double? fontSize;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.white,
        disabledForegroundColor: Colors.grey,
        padding: EdgeInsets.zero,
      ),
      child: OneLineText(
        widgetAlignment: Alignment.center,
        text: text ?? AppStrings.cancel,
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 16.0,
      ),
      onPressed: onPressed,
    );
  }
}
