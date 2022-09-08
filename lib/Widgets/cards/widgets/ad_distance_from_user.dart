import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:flutter/material.dart';

class AdDistanceFromUser extends StatelessWidget {
  const AdDistanceFromUser({
    required this.distanceText,
    super.key,
  });

  final String distanceText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          AutoSizeText(
            'Está a $distanceText de você',
            style: TextStyles.fontSize12(
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 8.0.w),
          Icon(
            Tiutiu.location_arrow,
            color: Colors.grey,
            size: 12.0.h,
          )
        ],
      ),
    );
  }
}
