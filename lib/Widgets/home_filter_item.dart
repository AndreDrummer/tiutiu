import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomeFilterItem extends StatelessWidget {
  const HomeFilterItem({
    this.isActive = false,
    required this.kind,
    required this.icon,
    this.onItemTap,
    super.key,
  });

  final Function()? onItemTap;
  final bool isActive;
  final IconData icon;
  final String kind;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0.w, color: Colors.green),
          color: isActive ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 4.0.h),
        height: 56.0.h,
        width: 56.0.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              color: isActive ? Colors.white : Colors.green,
              icon,
            ),
            SizedBox(height: 16),
            AutoSizeText(
              style: TextStyles.fontSize12(
                color: isActive ? Colors.white : Colors.green,
                fontWeight: FontWeight.w600,
              ),
              kind,
            )
          ],
        ),
      ),
    );
  }
}
