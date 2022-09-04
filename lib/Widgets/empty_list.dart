import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyListScreen extends StatelessWidget {
  EmptyListScreen({this.text, this.icon = Icons.sentiment_dissatisfied});

  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            style: TextStyles.fontSize16(),
            AppStrings.noPetFound,
          ),
          SizedBox(width: 10.0.w),
          Icon(icon),
        ],
      ),
    );
  }
}
