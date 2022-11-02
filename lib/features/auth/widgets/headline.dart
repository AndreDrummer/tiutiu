import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  const Headline({
    required this.text,
    this.textColor,
    super.key,
  });

  final Color? textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AutoSizeTexts.autoSizeText32(
      color: textColor ?? AppColors.primary,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.left,
      text,
    );
  }
}
