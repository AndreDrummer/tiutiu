import 'dart:io';

import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:tiutiu/features/auth/widgets/dark_over.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/tiutiu_logo.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
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
                  AutoSizeText(
                    AppStrings.headline1,
                    textAlign: TextAlign.center,
                    style: TextStyles.fontSize(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 32.0.sp,
                    ),
                  ),
                  SizedBox(height: 24.0.h),
                  AutoSizeText(
                    AppStrings.headline2,
                    textAlign: TextAlign.center,
                    style: TextStyles.fontSize(
                      fontWeight: FontWeight.w200,
                      color: AppColors.white,
                      fontSize: 20.0.sp,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ButtonWide(
                      text: AppStrings.getStarted,
                      color: AppColors.primary,
                      action: () {
                        homeController.showAuthHostersInFullScreen = true;
                        if (authController.userExists)
                          Get.toNamed(Routes.authOrHome);
                        Get.toNamed(Routes.authHosters);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: Platform.isIOS ? 32.0.h : 16.0.h,
            right: 8.0.w,
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
