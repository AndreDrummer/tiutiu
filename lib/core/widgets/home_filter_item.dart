import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HomeFilterItem extends StatelessWidget {
  const HomeFilterItem({
    this.isActive = false,
    required this.type,
    required this.icon,
    this.onItemTap,
    super.key,
  });

  final Function()? onItemTap;
  final bool isActive;
  final IconData icon;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0.w, color: AppColors.primary),
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 64.0.h,
        width: 64.0.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              color: isActive ? AppColors.white : AppColors.primary,
              icon,
            ),
            SizedBox(height: 16),
            AutoSizeTexts.autoSizeText12(
              color: isActive ? AppColors.white : AppColors.primary,
              fontWeight: FontWeight.w600,
              type,
            )
          ],
        ),
      ),
    );
  }
}
