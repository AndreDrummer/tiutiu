import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/remove_question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemoveAssetBlur extends StatelessWidget {
  const RemoveAssetBlur({
    required this.onRemove,
    required this.onClose,
    this.borderRadius,
    this.boxHeight,
    this.boxWidth,
    super.key,
  });

  final BorderRadius? borderRadius;
  final Function() onRemove;
  final Function() onClose;
  final double? boxHeight;
  final double? boxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight ?? 99.0.h,
      width: boxWidth ?? 168.0.w,
      decoration: BoxDecoration(
        color: AppColors.black.withAlpha(190),
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      ),
      child: RemoveQuestion(
        onRemove: () {
          onRemove();
          onClose();
        },
        spaceBetweenLines: 16.0.h,
        spaceBetweenIcons: 16.0.h,
        fontSize: 24.0.sp,
        onClose: onClose,
      ),
    );
  }
}
