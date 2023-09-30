import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClosedForMaintenance extends StatelessWidget {
  const ClosedForMaintenance({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Visibility(
          visible: !systemController.isToCloseApp,
          replacement: _MaintenanceScreen(),
          child: child,
        );
      },
    );
  }
}

class _MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appClosedMessageDescription = adminRemoteConfigController.configs.appClosedMessageDescription;
      final appClosedMessageTitle = adminRemoteConfigController.configs.appClosedMessageTitle;

      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              LottieAnimation(animationPath: AnimationsAssets.maintenance),
              AutoSizeTexts.autoSizeText20(
                appClosedMessageTitle.isNotEmptyNeighterNull()
                    ? appClosedMessageTitle
                    : AppLocalizations.of(context)!.closedForMaintenance,
                textAlign: TextAlign.center,
                color: AppColors.secondary,
              ),
              SizedBox(height: 8.0.h),
              AutoSizeTexts.autoSizeText12(
                appClosedMessageDescription.isNotEmptyNeighterNull()
                    ? appClosedMessageDescription
                    : AppLocalizations.of(context)!.willNotLate,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0.h),
              SimpleTextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.startScreen);
                },
                textColor: AppColors.primary,
                text: AppLocalizations.of(context)!.leave,
              ),
              Spacer(),
            ],
          ),
        ),
      );
    });
  }
}
