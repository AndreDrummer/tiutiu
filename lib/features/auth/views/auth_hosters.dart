import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/tiutiu_logo.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/system/controllers.dart';

class AuthHosters extends StatelessWidget {
  const AuthHosters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundImage(),
          _gradient(),
          _appLogo(),
          _headline(),
          _authButtons(),
          _continueAnonButton(),
        ],
      ),
    );
  }

  Container _backgroundImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            StartScreenAssets.munkun,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _gradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            AppColors.black.withOpacity(.9),
            AppColors.black.withOpacity(.6)
          ],
        ),
      ),
    );
  }

  Positioned _appLogo() {
    return Positioned(
      left: Get.width * .7,
      right: 8.0.w,
      top: 40.0.h,
      child: SizedBox(
        width: Get.width,
        child: TiutiuLogo(
          imageHeight: 28.0.h,
          textHeight: 16.0.h,
        ),
      ),
    );
  }

  Positioned _headline() {
    return Positioned(
      right: 8.0.h,
      left: 8.0.h,
      top: Get.height / 2,
      child: AutoSizeText(
        style: TextStyles.fontSize(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: 32.0.sp,
        ),
        textAlign: TextAlign.left,
        AuthStrings.authentique,
      ),
    );
  }

  Positioned _authButtons() {
    return Positioned(
      bottom: 32.0.h,
      left: 8.0.w,
      right: 8.0.w,
      child: Container(
        height: Get.height / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonWide(
              textIconColor: AppColors.black,
              icon: FontAwesomeIcons.apple,
              text: AuthStrings.apple,
              color: AppColors.white,
              isToExpand: true,
              action: () {},
            ),
            SizedBox(height: 8.0.h),
            ButtonWide(
              icon: FontAwesomeIcons.google,
              text: AuthStrings.google,
              color: AppColors.danger,
              isToExpand: true,
              action: () {},
            ),
            SizedBox(height: 8.0.h),
            ButtonWide(
              icon: FontAwesomeIcons.facebook,
              text: AuthStrings.facebook,
              color: AppColors.info,
              isToExpand: true,
              action: () {},
            ),
          ],
        ),
      ),
    );
  }

  Positioned _continueAnonButton() {
    return Positioned(
      bottom: 32.0.h,
      right: 0.0,
      left: 0.0,
      child: TextButton(
        style: TextButton.styleFrom(
          splashFactory: InkRipple.splashFactory,
          foregroundColor: Colors.transparent,
        ),
        child: AutoSizeText(
          style: TextStyles.fontSize(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            fontSize: 16.0.sp,
          ),
          textAlign: TextAlign.center,
          AuthStrings.continueAnon,
        ),
        onPressed: () {
          Get.back();
          homeController.bottomBarIndex = 0;
        },
      ),
    );
  }
}
