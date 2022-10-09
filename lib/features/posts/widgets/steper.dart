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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            stepsName.length,
            (index) => _SteperItem(
              isCompleted: currentStep > index,
              stepName: stepsName[index],
              stepNumber: index + 1,
              onStepTapped: () {},
            ),
          ),
        ),
        width: Get.width,
        height: 56.0.h,
      ),
    );
  }
}

class _SteperItem extends StatelessWidget {
  const _SteperItem({
    required this.isCompleted,
    required this.stepNumber,
    required this.stepName,
    this.onStepTapped,
  });

  final Function()? onStepTapped;
  final String stepName;
  final bool isCompleted;
  final int stepNumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStepTapped,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    margin: isCompleted
                        ? EdgeInsets.zero
                        : EdgeInsets.only(right: 24.0.w),
                    child: Image.asset(
                      color: isCompleted ? AppColors.primary : AppColors.white,
                      ImageAssets.newLogo,
                    ),
                    height: 32.0.h,
                    width: 32.0.h,
                  ),
                  Positioned(
                    left: 15.0.w,
                    top: 15.0.h,
                    child: AutoSizeText(
                      '$stepNumber',
                      textAlign: TextAlign.center,
                      style: TextStyles.fontSize(
                        color: isCompleted ? AppColors.white : AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: isCompleted ? 0.0.w : 24.0.w,
                  top: 2.0.h,
                ),
                child: AutoSizeText(
                  stepName,
                  textAlign: TextAlign.center,
                  style: TextStyles.fontSize(
                    color: isCompleted ? AppColors.primary : AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isCompleted && stepNumber < 5,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.0.h),
              color: AppColors.primary,
              width: 32,
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}
