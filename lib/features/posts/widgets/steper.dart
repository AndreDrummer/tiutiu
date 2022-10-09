import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Steper extends StatelessWidget {
  const Steper({
    required this.currentStep,
    required this.stepsName,
    super.key,
  });

  final List<String> stepsName;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0.h),
      elevation: 8.0.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0.h),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(24.0.h),
        ),
        child: Stack(
          children: [
            Row(
              children: List.generate(
                stepsName.length,
                (index) => _SteperItem(
                  isCompleted: currentStep > index,
                  stepName: stepsName[index],
                  stepsQty: stepsName.length,
                  stepNumber: index + 1,
                  onStepTapped: () {},
                ),
              ),
            ),
            Positioned(
              left: 56.0.w,
              top: 27.0.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  stepsName.length - 1,
                  (index) {
                    return Container(
                      color: currentStep > index
                          ? AppColors.primary
                          : AppColors.white,
                      margin: EdgeInsets.only(right: 32.0.w),
                      padding: EdgeInsets.zero,
                      width: 32.0.w,
                      height: 1,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        width: Get.width,
        height: 72.0.h,
      ),
    );
  }
}

class _SteperItem extends StatelessWidget {
  const _SteperItem({
    required this.isCompleted,
    required this.stepNumber,
    required this.stepsQty,
    required this.stepName,
    this.onStepTapped,
  });

  final Function()? onStepTapped;
  final bool isCompleted;
  final String stepName;
  final int stepNumber;
  final int stepsQty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStepTapped,
      child: Container(
        width: 64.0.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.0.w, top: 9.0.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                color: isCompleted ? AppColors.primary : AppColors.white,
                ImageAssets.newLogo,
              ),
              height: 28.0.h,
              width: 28.0.h,
            ),
            Container(
              height: 24.0.h,
              margin: EdgeInsets.only(top: 4.0.h, left: 16.0.w),
              alignment: Alignment.center,
              child: AutoSizeText(
                stepName,
                textAlign: TextAlign.center,
                style: TextStyles.fontSize(
                  color: isCompleted ? AppColors.primary : AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
