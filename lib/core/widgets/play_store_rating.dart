import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class RatingUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 24.0.h, horizontal: 8.0.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.h),
      ),
      child: Container(
        alignment: Alignment.center,
        height: Dimensions.getDimensBasedOnDeviceHeight(
          greaterDeviceHeightDouble: 112.0.h,
          minDeviceHeightDouble: 152.0.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buttons(
              context: context,
              imagePath: Platform.isAndroid ? ImageAssets.playstoreLogo : ImageAssets.applestoreLogo,
              text: 'Avalie na\n${Platform.isAndroid ? 'PlayStore' : 'Apple Store'}',
              urlToOpen: 'https://tiutiu.page.link/jdF1',
            ),
            buttons(
              urlToOpen: 'https://www.instagram.com/tiutiuapp/',
              imagePath: ImageAssets.instaLogo,
              text: '@tiutiuapp',
              context: context,
              bigger: true,
            ),
            buttons(
              urlToOpen: 'https://www.facebook.com/profile.php?id=100087589894761',
              text: 'Tiu, Tiu App',
              imagePath: ImageAssets.face,
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons({
    required BuildContext context,
    bool bigger = false,
    String? urlToOpen,
    String? imagePath,
    String? text,
  }) {
    return InkWell(
      onTap: () {
        Launcher.openBrowser(urlToOpen!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            height: bigger ? 96 : 64.0.h,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(imagePath!),
            ),
          ),
          AutoSizeTexts.autoSizeText8(
            fontWeight: FontWeight.w300,
            textAlign: TextAlign.center,
            fontSize: bigger ? 16 : 14,
            text,
          ),
        ],
      ),
    );
  }
}
