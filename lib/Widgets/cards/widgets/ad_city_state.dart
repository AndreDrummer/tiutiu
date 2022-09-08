import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AdCityState extends StatelessWidget {
  const AdCityState({
    super.key,
    required this.state,
    required this.city,
  });

  final String state;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Icon(Icons.pin_drop, size: 12.0.h, color: Colors.grey[400]),
          AutoSizeText(
            '$city - $state',
            style: TextStyles.fontSize12(
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
