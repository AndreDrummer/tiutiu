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
      margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.h),
      ),
      child: Container(
        alignment: Alignment.center,
        height: Dimensions.getDimensBasedOnDeviceHeight(
          greaterDeviceHeightDouble: 144.0.h,
          minDeviceHeightDouble: 152.0.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 16.0.w),
                AutoSizeTexts.autoSizeText16(
                  'Avalie-nos na',
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 24.0.w),
                AutoSizeTexts.autoSizeText16(
                  'Siga nos no',
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 40.0.w),
                AutoSizeTexts.autoSizeText16(
                  'Accesse',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttons(
                  context: context,
                  imagePath: Platform.isAndroid ? ImageAssets.playstoreLogo : ImageAssets.applestoreLogo,
                  urlToOpen: Platform.isAndroid ? 'https://cutt.ly/4gIMH8V' : 'https://cutt.ly/4gIMH8V',
                  text: 'Avalie-nos na ${Platform.isAndroid ? 'PlayStore' : 'Apple Store'}.',
                ),
                buttons(
                  urlToOpen: 'https://www.instagram.com/tiutiuapp/',
                  imagePath: ImageAssets.instaLogo,
                  text: '@tiutiuapp.',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AutoSizeTexts.autoSizeText16(
                  '${Platform.isAndroid ? 'PlayStore' : 'Apple Store'}.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 1.0.w),
                AutoSizeTexts.autoSizeText16(
                  '@tiutiuapp.',
                  textAlign: TextAlign.center,
                ),
                AutoSizeTexts.autoSizeText16(
                  'Tiu, Tiu App',
                  textAlign: TextAlign.center,
                ),
              ],
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
            height: bigger ? 96 : 72.0.h,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(imagePath!),
            ),
          ),
        ],
      ),
    );
  }
}
