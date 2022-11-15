import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/remove_question.dart';
import 'package:flutter/material.dart';

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
      margin: EdgeInsets.only(left: 4.0.w, top: 4.0.h),
      height: boxHeight ?? 199.0.h,
      width: boxWidth ?? 319.0.w,
      decoration: BoxDecoration(
        color: AppColors.black.withAlpha(200),
        borderRadius: borderRadius ?? BorderRadius.circular(8.0.h),
      ),
      child: RemoveQuestion(
        onRemove: () {
          onRemove();
          onClose();
        },
        spaceBetweenLines: 16.0.h,
        spaceBetweenIcons: 16.0.h,
        fontSize: 24.0,
        onClose: onClose,
      ),
    );
  }
}
