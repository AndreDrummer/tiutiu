import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
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
          height: Dimensions.getDimensBasedOnDeviceHeight(
            xSmaller: hasError ? Get.height / 2.8 : Get.height / 2.2,
            smaller: hasError ? Get.height / 3 : Get.height / 2.2,
            bigger: Get.height / 2.2,
            medium: Get.height / 2.2,
          ),
          child: Stack(
            children: [
              Icon(
                FontAwesomeIcons.video,
                color: hasError ? AppColors.danger : AppColors.white,
                size: 72.0.h,
              ),
              Positioned(
                left: 16.0.h,
                top: 24.0.h,
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: hasError ? AppColors.danger : Colors.blueGrey,
                  size: 24.0.h,
                ),
              )
            ],
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
