import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/column_button_bar.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:open_settings/open_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({
    this.onLeave,
    super.key,
  });

  final Function()? onLeave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieAnimation(
              animationPath: AnimationsAssets.noInternet,
              size: 120.0.h,
            ),
            SizedBox(height: 16.0.h),
            AutoSizeTexts.autoSizeText22(
              color: AppColors.black,
              AppLocalizations.of(context)!.noConnection,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 32.0.h),
              child: AutoSizeTexts.autoSizeText14(
                  color: AppColors.black,
                  AppLocalizations.of(context)!.noConnectionWarning2,
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 16.0.h),
            ColumnButtonBar(
              onSecondaryPressed: () => OpenSettings.openDataRoamingSetting(),
              onPrimaryPressed: () => OpenSettings.openWIFISetting(),
              textSecond: AppLocalizations.of(context)!.turnOnInternetMobile,
              textPrimary: AppLocalizations.of(context)!.turnOnWifi,
              isConnected: true,
            ),
            SimpleTextButton(
              onPressed: () {
                if (onLeave != null) {
                  onLeave?.call();
                } else {
                  Get.offAllNamed(Routes.startScreen);
                }
              },
              textColor: AppColors.secondary,
              text: AppLocalizations.of(context)!.leave,
            )
          ],
        ),
      ),
    );
  }
}
