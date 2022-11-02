import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
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
      child: AutoSizeTexts.autoSizeText10(
        '${AppStrings.postedAt} ${Formatter.getFormattedDate(createdAt)}',
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.left,
        color: Colors.grey,
      ),
    );
  }
}
