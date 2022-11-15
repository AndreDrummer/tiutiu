import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class InputCloseButton extends StatelessWidget {
  const InputCloseButton({super.key, this.onClose});

  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        margin: EdgeInsets.all(8.0.h),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 4),
          elevation: 2.0.h,
          color: Colors.purple[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
          child: Icon(
            color: AppColors.white,
            size: 12.0.h,
            Icons.close,
          ),
        ),
      ),
    );
  }
}
