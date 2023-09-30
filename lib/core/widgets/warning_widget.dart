import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningBanner extends StatelessWidget {
  const WarningBanner({
    this.adminCommunicationIsDanger = false,
    this.thereIsAdminCommunication = false,
    this.isHiddingContactInfo = false,
    this.showBannerCondition = false,
    this.adminLinkRedirection,
    required this.replacement,
    this.adminCommunication,
    this.textWarning,
    this.textColor,
    this.tileColor,
    this.tileSize,
    this.fontSize,
    this.padding,
    this.margin,
    super.key,
  });

  final bool adminCommunicationIsDanger;
  final bool thereIsAdminCommunication;
  final String? adminLinkRedirection;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? adminCommunication;
  final bool isHiddingContactInfo;
  final bool showBannerCondition;
  final String? textWarning;
  final Widget replacement;
  final double? tileSize;
  final double? fontSize;
  final Color? textColor;
  final Color? tileColor;

  String? getBannerText(BuildContext context) {
    if (thereIsAdminCommunication) {
      return adminCommunication;
    } else {
      return textWarning != null
          ? textWarning
          : isHiddingContactInfo
              ? AppLocalizations.of(context)!.verifyEmailToSeeContactInfo
              : AppLocalizations.of(context)!.verifyAccountWarning;
    }
  }

  Color? getBannerTextColor() {
    if (thereIsAdminCommunication) {
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
    if (thereIsAdminCommunication) {
      return adminCommunicationIsDanger ? AppColors.danger : AppColors.primary;
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
        if (adminLinkRedirection.isNotEmptyNeighterNull() && thereIsAdminCommunication) {
          Launcher.openBrowser('${adminLinkRedirection ?? adminRemoteConfigController.configs.appInstagramLink}');
        }
      },
      child: Visibility(
        visible: showBannerCondition,
        replacement: replacement,
        child: Card(
          margin: EdgeInsets.only(top: 4.0.h),
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0.h)),
          child: Container(
            height: tileSize ?? 24.0.h,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
            margin: margin ?? EdgeInsets.symmetric(vertical: 32.0.h),
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
                    getBannerText(context),
                    color: getBannerTextColor(),
                    textOverflow: TextOverflow.fade,
                    textAlign: TextAlign.left,
                    fontSize: fontSize ?? 12,
                  ),
                ),
                Visibility(
                  visible: !thereIsAdminCommunication,
                  child: Icon(
                    Icons.warning,
                    size: 12.0.h,
                    color: textColor != null
                        ? textColor
                        : isHiddingContactInfo
                            ? AppColors.black
                            : AppColors.white,
                  ),
                  replacement: Icon(color: AppColors.white, Icons.launch, size: 12.0.h),
                ),
                SizedBox(width: 2.0.w),
              ],
            ),
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
          height: Get.width / 3.5,
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
              Icon(
                color: isHiddingContactInfo ? AppColors.black : AppColors.white,
                !isLoggedIn ? Icons.login : Icons.warning,
                size: 24.0.h,
              ),
              AutoSizeTexts.autoSizeText24(
                isHiddingContactInfo
                    ? !isLoggedIn
                        ? AppLocalizations.of(context)!.doLoginWarning
                        : AppLocalizations.of(context)!.verifyEmailToSeeContactInfo
                    : AppLocalizations.of(context)!.verifyAccountWarning,
                color: isHiddingContactInfo ? AppColors.black : AppColors.white,
                textOverflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                fontSize: fontSize ?? 24,
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
      final showInfoBanner = authController.userExists && !tiutiuUserController.tiutiuUser.emailVerified;
      final thereIsAdminCommunication = adminRemoteConfigController.configs.thereIsAdminCommunication;
      final adminLinkRedirection = adminRemoteConfigController.configs.adminLinkRedirectsTo;
      final internetConnected = systemController.properties.internetConnected;

      final adminCommunication = Formatters.cuttedText(
        adminRemoteConfigController.configs.adminCommunication,
        size: 200,
      );

      final tileSize = Formatters.cuttedText(adminCommunication).length.toDouble() + 8.0.h;

      return WarningBanner(
        adminCommunicationIsDanger: adminRemoteConfigController.configs.adminCommunicationIsDanger,
        showBannerCondition: (thereIsAdminCommunication || showInfoBanner) && internetConnected,
        margin: EdgeInsets.only(top: thereIsAdminCommunication ? 0 : 4.0.h),
        padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
        tileSize: thereIsAdminCommunication ? tileSize : null,
        thereIsAdminCommunication: thereIsAdminCommunication,
        adminLinkRedirection: adminLinkRedirection,
        adminCommunication: adminCommunication,
        replacement: SizedBox.shrink(),
      );
    });
  }
}
