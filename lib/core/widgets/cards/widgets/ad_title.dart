import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/formatter.dart';
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
      margin: EdgeInsets.only(bottom: 2.0.h),
      child: AutoSizeTexts.autoSizeText16(
        Formatters.cuttedText(title, size: 32),
        textOverflow: TextOverflow.fade,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
