import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class TextButtonCount extends StatelessWidget {
  const TextButtonCount({super.key, required this.padding, this.fontSize = 14, required this.text});

  final EdgeInsetsGeometry padding;
  final double fontSize;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: AutoSizeTexts.autoSizeText(
        textAlign: TextAlign.center,
        color: AppColors.whiteIce,
        fontSize: fontSize,
        text,
      ),
    );
  }
}
