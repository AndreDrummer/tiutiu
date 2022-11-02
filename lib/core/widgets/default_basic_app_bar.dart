import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultBasicAppBar extends AppBar {
  DefaultBasicAppBar({required String text, bool automaticallyImplyLeading = true})
      : super(
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: AutoSizeTexts.autoSizeText12(text),
          backgroundColor: AppColors.primary,
        );
}
