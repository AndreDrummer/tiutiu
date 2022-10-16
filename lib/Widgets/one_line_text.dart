import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/text_styles.dart';

class OneLineText extends StatelessWidget {
  const OneLineText({
    this.widgetAlignment,
    required this.text,
    this.fontSize = 14,
    this.fontWeight,
    this.textAlign,
    this.color,
    super.key,
  });

  final Alignment? widgetAlignment;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double fontSize;
  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Align(
        alignment: widgetAlignment ?? Alignment(-0.95, 1),
        child: AutoSizeText(
          text,
          style: TextStyles.fontSize(
            fontWeight: fontWeight ?? FontWeight.w600,
            fontSize: fontSize,
            color: color,
          ),
          overflow: TextOverflow.fade,
          textAlign: textAlign,
          maxFontSize: 32,
        ),
      ),
    );
  }
}
