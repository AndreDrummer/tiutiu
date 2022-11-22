import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultBasicAppBar extends AppBar {
  DefaultBasicAppBar({
    required String text,
    bool automaticallyImplyLeading = true,
    Color? backgroundColor,
    List<Widget>? actions,
    Widget? leading,
  }) : super(
          backgroundColor: backgroundColor ?? AppColors.primary,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: AutoSizeTexts.autoSizeText20(text),
          leading: leading,
          actions: actions,
        );
}
