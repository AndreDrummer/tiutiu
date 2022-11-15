import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/auth/widgets/dark_over.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageCarouselBackground(),
          DarkOver(),
          Positioned(
            bottom: 8.0.h,
            right: 0.0.h,
            left: 0.0.h,
            child: Container(
              alignment: Alignment.center,
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeTexts.autoSizeText32(
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    AppStrings.headline1,
                    fontSize: 32.0,
                  ),
                  SizedBox(height: 24.0.h),
                  AutoSizeTexts.autoSizeText22(
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w300,
                    color: AppColors.white,
                    AppStrings.headline2,
                    fontSize: 20.0,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ButtonWide(
                      text: AppStrings.getStarted,
                      color: AppColors.primary,
                      onPressed: () {
                        if (authController.userExists) Get.toNamed(Routes.home);
                        Get.toNamed(Routes.authHosters);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 8.0.w,
            top: 32.0.h,
            left: 8.0.w,
            child: SizedBox(
              width: Get.width,
              child: TiutiuLogo(),
            ),
          ),
        ],
      ),
    );
  }
}
