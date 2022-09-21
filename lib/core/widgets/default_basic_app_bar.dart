import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DefaultBasicAppBar extends AppBar {
  DefaultBasicAppBar({
    required String text,
  }) : super(
          title: AutoSizeText(
            style: TextStyles.fontSize16(),
            text,
          ),
          automaticallyImplyLeading: true,
        );
}
