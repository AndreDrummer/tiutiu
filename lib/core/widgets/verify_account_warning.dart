import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class VerifyAccountWarning extends StatelessWidget {
  const VerifyAccountWarning({
    this.anotherRequiredCondition = false,
    this.isHiddingContactInfo = false,
    required this.child,
    this.fontSize,
    this.padding,
    this.margin,
    super.key,
  });

  final bool anotherRequiredCondition;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isHiddingContactInfo;
  final double? fontSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !anotherRequiredCondition && tiutiuUserController.tiutiuUser.emailVerified,
      child: child,
      replacement: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
        margin: margin ?? EdgeInsets.symmetric(vertical: 32.0.h, horizontal: 8.0.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHiddingContactInfo ? Colors.amber : AppColors.danger,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AutoSizeTexts.autoSizeText12(
                isHiddingContactInfo ? AppStrings.verifyEmailToSeeContactInfo : AppStrings.verifyEmailWarning,
                color: isHiddingContactInfo ? AppColors.black : AppColors.white,
                textOverflow: TextOverflow.fade,
                textAlign: TextAlign.left,
                fontSize: fontSize,
              ),
            ),
            Icon(Icons.warning, size: 12.0.h, color: isHiddingContactInfo ? AppColors.black : AppColors.white),
          ],
        ),
      ),
    );
  }
}
