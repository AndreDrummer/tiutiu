import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Badge({
    this.color = Colors.blue,
    this.textSize = 10,
    this.show = false,
    this.text,
  });

  final double textSize;
  final Color color;
  final bool show;
  final text;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: AutoSizeTexts.autoSizeText8(
            fontWeight: FontWeight.w600,
            color: AppColors.white,
            text.toString(),
          ),
        ),
      ),
    );
  }
}
