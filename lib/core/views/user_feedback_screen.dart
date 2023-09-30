import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFeedbackScreen extends StatelessWidget {
  const UserFeedbackScreen({
    this.showLogoutOption = true,
    this.onErrorCallback,
    this.feedbackMessage,
    this.error,
    this.icon,
    super.key,
  });

  final void Function()? onErrorCallback;
  final String? feedbackMessage;
  final bool showLogoutOption;
  final IconData? icon;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            TiutiuLogo(),
            Spacer(),
            Icon(
              color: AppColors.white,
              icon ?? Icons.info,
              size: 24.0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0.h),
              child: AutoSizeTexts.autoSizeText16(
                feedbackMessage ?? AppLocalizations.of(context)!.tryAgainInABrief,
                textAlign: TextAlign.center,
                color: AppColors.white,
              ),
            ),
            Spacer(),
            Visibility(
              visible: showLogoutOption,
              child: TextButton.icon(
                icon: Icon(
                  color: AppColors.white,
                  Icons.exit_to_app,
                  size: 14.0.h,
                ),
                label: AutoSizeTexts.autoSizeText16(
                  color: AppColors.white,
                  AppLocalizations.of(context)!.leave,
                ),
                onPressed: () async {
                  if (onErrorCallback != null) {
                    onErrorCallback?.call();
                  } else {
                    await authController.signOut().then((_) {
                      Get.offAllNamed(Routes.startScreen);
                      homeController.setMoreIndex();
                    });
                  }
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
