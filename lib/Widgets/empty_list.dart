import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({
    this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AutoSizeTexts.autoSizeText16(text ?? AppStrings.noPetFound),
      alignment: Alignment.center,
    );
  }
}
