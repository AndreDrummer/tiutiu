import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';

class AdPostedAt extends StatelessWidget {
  const AdPostedAt({
    super.key,
    required this.createdAt,
  });

  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.0.h,
      width: 200.0.w,
      child: AutoSizeText(
        '${AppStrings.postedAt} ${Formatter.getFormattedDate(createdAt)}',
        textAlign: TextAlign.left,
        style: TextStyles.fontSize12(
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
      ),
    );
  }
}
