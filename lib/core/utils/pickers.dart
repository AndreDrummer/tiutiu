import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
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
    systemController.bottomSheetIsOpen = true;
    showBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0.h),
          topLeft: Radius.circular(12.0.h),
        ),
      ),
      context: context,
      enableDrag: true,
      elevation: 16.0,
      builder: (context) {
        return Container(
          height: systemController.properties.snackBarIsOpen ? 112.0.h : 100.0.h,
          child: Column(
            children: [
              TextButton(
                child: Text(
                  pickerAssetType == PickerAssetType.photo ? AppStrings.takeApicture : AppStrings.recordVideo,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14.0,
                  ),
                ),
                onPressed: () async {
                  systemController.bottomSheetIsOpen = false;
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
              Divider(),
              TextButton(
                child: Text(
                  style: TextStyle(fontSize: 14.0),
                  AppStrings.openGallery,
                ),
                onPressed: () async {
                  systemController.bottomSheetIsOpen = false;
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
              ),
            ],
          ),
        );
      },
    );
  }
}
