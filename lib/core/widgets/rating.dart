import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
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
          smaller: 152.0.h,
          medium: 152.0.h,
          bigger: 120.0.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buttons(
              icon: Platform.isAndroid ? FontAwesomeIcons.googlePlay : FontAwesomeIcons.apple,
              text: 'Avalie-nos\n${Platform.isAndroid ? 'PlayStore' : 'Apple Store'}',
              color: Platform.isAndroid ? Colors.green : Colors.black,
              urlToOpen: Platform.isAndroid
                  ? adminRemoteConfigController.configs.playStoreLink
                  : adminRemoteConfigController.configs.appleStoreLink,
              context: context,
            ),
            buttons(
              urlToOpen: adminRemoteConfigController.configs.appTikTokLink,
              text: adminRemoteConfigController.configs.appTikTokUser,
              icon: FontAwesomeIcons.tiktok,
              color: Color(0XFF000000),
              context: context,
              bigger: false,
            ),
            buttons(
              urlToOpen: adminRemoteConfigController.configs.appInstagramLink,
              text: adminRemoteConfigController.configs.appInstagramUser,
              icon: FontAwesomeIcons.instagram,
              color: Color(0XFFE41F30),
              context: context,
              bigger: false,
            ),
            buttons(
              urlToOpen: adminRemoteConfigController.configs.appFacebookLink,
              text: adminRemoteConfigController.configs.appFacebookUser,
              icon: FontAwesomeIcons.facebook,
              color: Colors.blue,
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
    Color? color,
    IconData? icon,
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
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(
              size: bigger ? 40 : 24,
              icon,
              color: AppColors.white,
            ),
          ),
          Container(
            height: 32.0.h,
            child: AutoSizeTexts.autoSizeText8(
              fontWeight: FontWeight.w300,
              textAlign: TextAlign.center,
              fontSize: bigger ? 16 : 14,
              text,
            ),
          ),
        ],
      ),
    );
  }
}
