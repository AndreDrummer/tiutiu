import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';

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
          Icon(FontAwesomeIcons.eye, size: 10.0.h, color: Colors.grey[400]),
          Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: AutoSizeTexts.autoSizeText12(
              fontWeight: FontWeight.w400,
              '$views ${AppStrings.views}',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
