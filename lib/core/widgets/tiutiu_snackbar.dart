import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TiuTiuSnackBar extends SnackBar {
  TiuTiuSnackBar({super.key, required this.message, this.color})
      : super(
          backgroundColor: color ?? AppColors.info,
          content: AutoSizeTexts.autoSizeText14(message),
          duration: Duration(milliseconds: 1500),
        );

  final Color? color;

  final String message;
}
