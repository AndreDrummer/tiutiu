import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        onTap: () {
          if (systemController.properties.bottomSheetIsOpen) {
            Get.back();
            systemController.bottomSheetIsOpen = false;
          } else {
            pickAnAsset(
              pickerAssetType: PickerAssetType.video,
              onAssetPicked: onVideoPicked,
              context: context,
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: Get.height / 3,
          child: Icon(
            color: hasError ? AppColors.danger : AppColors.white,
            Icons.video_call_outlined,
            size: 72.0.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black.withAlpha(25)),
            borderRadius: BorderRadius.all(Radius.circular(16.0.h)),
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
