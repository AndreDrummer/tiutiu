import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';

class HomeFilterItem extends StatelessWidget {
  const HomeFilterItem({
    this.isActive = false,
    required this.image,
    required this.type,
    this.onItemTap,
    super.key,
  });

  final Function()? onItemTap;
  final bool isActive;
  final String image;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: 3.0.w),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0.w, color: AppColors.primary),
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: 64.0.w,
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 3 / 2.3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: AssetHandle.getImage(
                  fit: BoxFit.cover,
                  image,
                ),
              ),
            ),
            AutoSizeTexts.autoSizeText10(
              color: isActive ? AppColors.white : AppColors.primary,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
              type,
            )
          ],
        ),
      ),
    );
  }
}
