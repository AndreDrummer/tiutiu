import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:flutter/material.dart';

class AdViews extends StatelessWidget {
  const AdViews({
    super.key,
    required this.views,
  });

  final int views;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Icon(Tiutiu.eye, size: 12.0.h, color: Colors.grey[400]),
          Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: AutoSizeText(
              '$views ${AppStrings.views}',
              style: TextStyles.fontSize12(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
