import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({
    this.icon = Icons.sentiment_dissatisfied,
    this.text,
  });

  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeTexts.autoSizeText16(AppStrings.noPetFound),
          SizedBox(width: 10.0.w),
          Icon(icon),
        ],
      ),
    );
  }
}
