import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
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
    final statesInitials = DummyData.statesInitials;
    final statesName = DummyData.statesName;

    String UF = statesInitials.elementAt(statesName.indexOf(state));

    return Container(
      width: 200.0.w,
      margin: EdgeInsets.only(bottom: 8.0.h),
      child: Row(
        children: [
          Spacer(),
          Icon(Icons.pin_drop, size: 12.0.h, color: Colors.grey[400]),
          AutoSizeText(
            '$city - $UF',
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
