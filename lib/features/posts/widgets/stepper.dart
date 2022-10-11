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
    int n = 7;
    return Card(
      margin: EdgeInsets.all(8.0.h),
      elevation: 8.0.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0.h),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0.h),
          color: AppColors.black,
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stepsName.length - n,
                (index) => _SteperItem(
                  isCompleted: currentStep > index,
                  stepsQty: stepsName.length,
                  stepName: stepsName[index],
                  stepNumber: index + 1,
                  onStepTapped: () {},
                ),
              ),
            ),
            Positioned(
              right: 0.0.w,
              top: 16.0.h,
              left: 0.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  stepsName.length - (n + 1),
                  (index) {
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1000),
                      tween: ColorTween(
                        begin: currentStep > index
                            ? AppColors.white
                            : AppColors.primary,
                        end: currentStep > index
                            ? AppColors.primary
                            : AppColors.white,
                      ),
                      builder: (context, color, _) {
                        return Container(
                          padding: EdgeInsets.zero,
                          color: color as Color,
                          width: 16.0.w,
                          height: 1,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
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
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.0.h),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 250),
                tween: ColorTween(
                  begin: isCompleted ? AppColors.white : AppColors.primary,
                  end: isCompleted ? AppColors.primary : AppColors.white,
                ),
                builder: (context, color, _) {
                  return Image.asset(
                    color: color as Color,
                    ImageAssets.newLogo,
                  );
                },
              ),
              height: 16.0.h,
              width: 16.0.h,
            ),
            Container(
              alignment: Alignment.center,
              child: AutoSizeText(
                style: TextStyles.fontSize(
                  color: isCompleted ? AppColors.primary : AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                minFontSize: 8.0,
                maxFontSize: 10.0,
                stepName,
              ),
              width: 40.0.w,
              height: 24.0.h,
            )
          ],
        ),
      ),
    );
  }
}
