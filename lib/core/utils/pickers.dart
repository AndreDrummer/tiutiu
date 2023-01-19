import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

enum PickerAssetType {
  photo,
  video,
}

mixin Pickers {
  Future<void> pickAnAsset({
    required void Function(File?) onAssetPicked,
    required PickerAssetType pickerAssetType,
    required BuildContext context,
  }) async {
    final ImagePicker _picker = ImagePicker();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 64.0.h,
            child: Column(
              children: [
                selectResourceText(
                  text: pickerAssetType == PickerAssetType.photo ? AppStrings.takeApicture : AppStrings.recordVideo,
                  color: AppColors.primary,
                  onTap: () async {
                    Get.back();
                    var pic;
                    switch (pickerAssetType) {
                      case PickerAssetType.photo:
                        pic = await _picker.pickImage(source: ImageSource.camera);
                        break;
                      case PickerAssetType.video:
                        pic = await _picker.pickVideo(source: ImageSource.camera);
                    }

                    if (pic != null) onAssetPicked(File(pic.path));
                  },
                ),
                Divider(height: 32.0.h),
                selectResourceText(
                  text: AppStrings.openGallery,
                  color: AppColors.secondary,
                  onTap: () async {
                    Get.back();
                    var pic;
                    switch (pickerAssetType) {
                      case PickerAssetType.photo:
                        pic = await _picker.pickImage(source: ImageSource.gallery);
                        break;
                      case PickerAssetType.video:
                        pic = await _picker.pickVideo(source: ImageSource.gallery);
                    }

                    if (pic != null) onAssetPicked(File(pic.path));
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selectResourceText({required Function()? onTap, required String text, required Color color}) {
    return GestureDetector(
      child: SizedBox(
        height: 16.0.h,
        width: Get.width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            color: color,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
