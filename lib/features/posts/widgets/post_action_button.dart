import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PostActionButton extends StatelessWidget {
  const PostActionButton({super.key, required this.icon, this.size});

  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0.h),
      child: Icon(
        color: AppColors.secondary,
        icon,
        size: size ?? 24.0.h,
      ),
    );
  }
}
