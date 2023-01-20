import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/column_button_bar.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:open_settings/open_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnectionScreen extends StatelessWidget {
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
              color: AppColors.secondary,
              AppStrings.noConnection,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 32.0.h),
              child: AutoSizeTexts.autoSizeText14(
                  color: AppColors.secondary,
                  'É preciso estar conectado a alguma rede de internet para conseguir adotar um PET, ou até mesmo para postar um para adoção ou que esteja desaparecido!',
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 16.0.h),
            ColumnButtonBar(
              onSecondaryPressed: () => OpenSettings.openDataRoamingSetting(),
              onPrimaryPressed: () => OpenSettings.openWIFISetting(),
              textSecond: 'Ligar Internet Móvel (3G, 4G ou 5G)',
              textPrimary: 'Ligar Wi-FI',
              isConnected: true,
            ),
            SimpleTextButton(
              onPressed: () => Get.offAllNamed(Routes.startScreen),
              textColor: AppColors.secondary,
              text: AppStrings.leave,
            )
          ],
        ),
      ),
    );
  }
}
