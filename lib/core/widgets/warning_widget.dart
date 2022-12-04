import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningBanner extends StatelessWidget {
  const WarningBanner({
    this.isHiddingContactInfo = false,
    this.showBannerCondition = false,
    required this.replacement,
    this.textWarning,
    this.fontSize,
    this.textColor,
    this.tileColor,
    this.tileSize,
    this.padding,
    this.margin,
    super.key,
  });
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isHiddingContactInfo;
  final bool showBannerCondition;
  final String? textWarning;
  final Widget replacement;
  final double? tileSize;
  final double? fontSize;
  final Color? textColor;
  final Color? tileColor;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = authController.userExists;

    return Visibility(
      visible: showBannerCondition,
      replacement: replacement,
      child: Visibility(
        visible: isLoggedIn,
        child: Container(
          height: tileSize ?? 24.0.h,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          margin: margin ?? EdgeInsets.symmetric(vertical: 32.0.h, horizontal: 8.0.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tileColor != null
                ? tileColor
                : isHiddingContactInfo
                    ? Colors.amber
                    : AppColors.danger,
            borderRadius: BorderRadius.circular(4.0.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AutoSizeTexts.autoSizeText12(
                  textWarning != null
                      ? textWarning
                      : isHiddingContactInfo
                          ? AppStrings.verifyEmailToSeeContactInfo
                          : AppStrings.verifyAccountWarning,
                  color: textColor != null
                      ? textColor
                      : isHiddingContactInfo
                          ? AppColors.black
                          : AppColors.white,
                  textOverflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  fontSize: fontSize,
                ),
              ),
              Icon(
                Icons.warning,
                size: 12.0.h,
                color: textColor != null
                    ? textColor
                    : isHiddingContactInfo
                        ? AppColors.black
                        : AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyAccountWarningInterstitial extends StatelessWidget {
  const VerifyAccountWarningInterstitial({
    this.isHiddingContactInfo = false,
    required this.child,
    this.fontSize,
    this.padding,
    this.margin,
    super.key,
  });

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isHiddingContactInfo;
  final double? fontSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = authController.userExists;

    return Visibility(
      visible: tiutiuUserController.tiutiuUser.emailVerified,
      child: child,
      replacement: Container(
        height: Get.width / 4,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
        margin: margin ?? EdgeInsets.symmetric(vertical: 32.0.h, horizontal: 6.0.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHiddingContactInfo ? Colors.amber : AppColors.danger,
          borderRadius: BorderRadius.circular(8.0.h),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(!isLoggedIn ? Icons.login : Icons.warning,
                size: 32.0.h, color: isHiddingContactInfo ? AppColors.black : AppColors.white),
            AutoSizeTexts.autoSizeText24(
              isHiddingContactInfo
                  ? !isLoggedIn
                      ? AppStrings.doLoginWarning
                      : AppStrings.verifyEmailToSeeContactInfo
                  : AppStrings.verifyAccountWarning,
              color: isHiddingContactInfo ? AppColors.black : AppColors.white,
              textOverflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              fontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }
}
