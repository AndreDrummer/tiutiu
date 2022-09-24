import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

class Badge extends StatelessWidget {
  Badge({
    this.text,
    this.color = Colors.blue,
    this.textSize = 10,
  });

  final text;
  final double textSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: AutoSizeText(
          text.toString(),
          style: TextStyle(
            color: AppColors.white,
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
