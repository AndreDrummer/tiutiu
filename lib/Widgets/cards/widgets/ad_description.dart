import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AdDescription extends StatelessWidget {
  const AdDescription({
    required this.description,
    super.key,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: AutoSizeText(
        description,
        style: TextStyles.fontSize12(
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
    );
  }
}
