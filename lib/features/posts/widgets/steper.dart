import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Steper extends StatelessWidget {
  const Steper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0.h),
      elevation: 5,
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
            5,
            (index) => _SteperItem(
              isCompleted: index < 90,
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
    this.onStepTapped,
  });

  final Function()? onStepTapped;
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
                        color:
                            isCompleted ? AppColors.white : AppColors.primary,
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
                  'Nome',
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
