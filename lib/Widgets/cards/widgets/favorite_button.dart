import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    this.pressed = false,
    super.key,
  });

  final bool pressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Icon(
            pressed ? Icons.favorite : Icons.favorite_border,
            size: 16.0.h,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
