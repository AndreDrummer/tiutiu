import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddVideoItem extends StatelessWidget with Pickers {
  const AddVideoItem({
    required this.onVideoPicked,
    required this.hasError,
    super.key,
  });

  final Function(File?) onVideoPicked;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0.h)),
      ),
      child: GestureDetector(
        onTap: () => pickAnAsset(
          pickerAssetType: PickerAssetType.video,
          onAssetPicked: onVideoPicked,
          context: context,
        ),
        child: Container(
          alignment: Alignment.center,
          height: 140.0.h,
          width: 240.0.w,
          child: Icon(
            color: hasError ? AppColors.danger : AppColors.white,
            Icons.video_call_outlined,
            size: 56.0.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.black.withAlpha(100),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(16.0.h),
            ),
            color: AppColors.black.withAlpha(120),
          ),
        ),
      ),
    );
  }
}
