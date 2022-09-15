import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AdTitle extends StatelessWidget {
  const AdTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0.h),
      child: AutoSizeText(
        maxLines: 2,
        style: TextStyles.fontSize20(
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.fade,
        title,
      ),
      width: 144.0.w,
    );
  }
}
