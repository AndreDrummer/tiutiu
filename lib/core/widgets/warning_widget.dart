import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningBanner extends StatelessWidget {
  const WarningBanner({
    this.thereIsDeveloperCommunication = false,
    this.isHiddingContactInfo = false,
    this.showBannerCondition = false,
    this.developerLinkRedirection,
    this.developerCommunication,
    required this.replacement,
    this.textWarning,
    this.textColor,
    this.tileColor,
    this.tileSize,
    this.fontSize,
    this.padding,
    this.margin,
    super.key,
  });

  final bool thereIsDeveloperCommunication;
  final String? developerLinkRedirection;
  final String? developerCommunication;
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

  String? getBannerText() {
    if (thereIsDeveloperCommunication) {
      return developerCommunication;
    } else {
      return textWarning != null
          ? textWarning
          : isHiddingContactInfo
              ? AppStrings.verifyEmailToSeeContactInfo
              : AppStrings.verifyAccountWarning;
    }
  }

  Color? getBannerTextColor() {
    if (thereIsDeveloperCommunication) {
      return AppColors.white;
    } else {
      return textColor != null
          ? textColor
          : isHiddingContactInfo
              ? AppColors.black
              : AppColors.white;
    }
  }

  Color? getBannerBackgroundcolor() {
    if (thereIsDeveloperCommunication) {
      return AppColors.primary;
    } else {
      return tileColor != null
          ? tileColor
          : isHiddingContactInfo
              ? Colors.amber
              : AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (developerLinkRedirection.isNotEmptyNeighterNull()) {
          Launcher.openBrowser('${developerLinkRedirection ?? Constants.APP_INSTAGRAM_PAGE}');
        }
      },
      child: Visibility(
        visible: showBannerCondition,
        replacement: replacement,
        child: Container(
          height: tileSize ?? 24.0.h,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          margin: margin ?? EdgeInsets.symmetric(vertical: 32.0.h, horizontal: 8.0.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: getBannerBackgroundcolor(),
            borderRadius: BorderRadius.circular(4.0.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 2.0.w),
              Expanded(
                child: AutoSizeTexts.autoSizeText12(
                  getBannerText(),
                  color: getBannerTextColor(),
                  textOverflow: TextOverflow.fade,
                  textAlign: TextAlign.left,
                  fontSize: fontSize,
                ),
              ),
              Visibility(
                visible: !thereIsDeveloperCommunication,
                child: Icon(
                  Icons.warning,
                  size: 12.0.h,
                  color: textColor != null
                      ? textColor
                      : isHiddingContactInfo
                          ? AppColors.black
                          : AppColors.white,
                ),
                replacement: Icon(color: AppColors.white, Icons.info_outlined, size: 12.0.h),
              ),
              SizedBox(width: 2.0.w),
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
    this.action,
    this.margin,
    super.key,
  });

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isHiddingContactInfo;
  final Function()? action;
  final double? fontSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = authController.userExists;

    return GestureDetector(
      onTap: () {
        if (!tiutiuUserController.tiutiuUser.emailVerified) {
          action?.call();

          if (authController.userExists) {
            Get.offNamed(Routes.verifyEmail);
          } else {
            Get.offNamed(Routes.authHosters);
          }
        }
      },
      child: Visibility(
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
      ),
    );
  }
}

class HighPriorityInfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final thereIsDeveloperCommunication = appController.properties.thereIsDeveloperCommunication;
      final developerLinkRedirection = appController.properties.developerLinkRedirection;

      final showInfoBanner = authController.userExists &&
          (!appController.properties.internetConnected || !tiutiuUserController.tiutiuUser.emailVerified);

      return WarningBanner(
        margin: EdgeInsets.only(top: thereIsDeveloperCommunication ? 0 : 4.0.h),
        developerCommunication: appController.properties.developerCommunication,
        showBannerCondition: thereIsDeveloperCommunication || showInfoBanner,
        padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
        thereIsDeveloperCommunication: thereIsDeveloperCommunication,
        tileSize: thereIsDeveloperCommunication ? 36.0.h : null,
        developerLinkRedirection: developerLinkRedirection,
        replacement: SizedBox.shrink(),
      );
    });
  }
}
