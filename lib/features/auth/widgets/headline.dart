import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    return AutoSizeText(
      style: TextStyles.fontSize(
        color: textColor ?? AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 32.0.sp,
      ),
      textAlign: TextAlign.left,
      text,
    );
  }
}
