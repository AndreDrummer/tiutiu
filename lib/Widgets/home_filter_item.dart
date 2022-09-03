import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomeFilterItem extends StatelessWidget {
  const HomeFilterItem({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0.w, color: Colors.green),
        color: isActive ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
      height: 56.0.h,
      width: 56.0.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.dog,
            color: isActive ? Colors.white : Colors.green,
          ),
          SizedBox(
            height: 16,
          ),
          AutoSizeText(
            'Cachorro',
            style: TextStyles.fontSize12(
              color: isActive ? Colors.white : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
