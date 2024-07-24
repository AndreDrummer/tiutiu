import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultBasicAppBar extends AppBar {
  DefaultBasicAppBar({
    required String text,
    bool automaticallyImplyLeading = true,
    Color? backgroundColor,
    List<Widget>? actions,
    Color? textColor,
    Widget? leading,
  }) : super(
          title: AutoSizeTexts.autoSizeText16(
            text,
            color: textColor ?? AppColors.white,
          ),
          leading: leading ?? BackButton(color: AppColors.white),
          backgroundColor: backgroundColor ?? AppColors.primary,
          automaticallyImplyLeading: automaticallyImplyLeading,
          actions: actions,
        );
}
