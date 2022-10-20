import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/auth/widgets/headline.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/tiutiu_logo.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class AuthHosters extends StatelessWidget with TiuTiuPopUp {
  const AuthHosters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundImage(),
          _gradient(),
          _appLogo(),
          Positioned(
            bottom: 8.0.h,
            left: 8.0,
            right: 8.0,
            child: Column(
              children: [
                _headline(),
                SizedBox(height: 16.0.h),
                _authButtons(),
                _continueAnonButton()
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _backgroundImage() {
    final photos = authController.startScreenImages;
    final nextImage = Random().nextInt(photos.length);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            photos[nextImage],
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
            AppColors.black.withOpacity(.4)
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
        child: TiutiuLogo(color: AppColors.primary),
      ),
    );
  }

  Widget _headline() =>
      Headline(text: AuthStrings.authentique, textColor: AppColors.white);

  Widget _authButtons() {
    return Container(
      height: Get.height / 2.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonWide(
            textIconColor: AppColors.black,
            icon: FontAwesomeIcons.apple,
            onPressed: _loginWithApple,
            text: AuthStrings.apple,
            color: AppColors.white,
            isToExpand: true,
          ),
          SizedBox(height: 4.0.h),
          ButtonWide(
            icon: FontAwesomeIcons.envelope,
            text: AuthStrings.email,
            color: Colors.grey,
            isToExpand: true,
            onPressed: () {
              Get.toNamed(Routes.emailAndPassword);
            },
          ),
          SizedBox(height: 4.0.h),
          ButtonWide(
            icon: FontAwesomeIcons.google,
            onPressed: _loginWithGoogle,
            text: AuthStrings.google,
            color: AppColors.danger,
            isToExpand: true,
          ),
          SizedBox(height: 4.0.h),
          ButtonWide(
            icon: FontAwesomeIcons.facebook,
            onPressed: _loginWithFacebook,
            text: AuthStrings.facebook,
            color: AppColors.info,
            isToExpand: true,
          ),
        ],
      ),
    );
  }

  Widget _continueAnonButton() {
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: InkRipple.splashFactory,
        foregroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
      child: AutoSizeText(
        style: TextStyles.fontSize(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
          fontSize: 16.0.sp,
        ),
        textAlign: TextAlign.center,
        AuthStrings.continueAnon,
        maxFontSize: 18.0,
      ),
      onPressed: () {
        Get.toNamed(Routes.home);
        homeController.bottomBarIndex = 0;
      },
    );
  }

  void _loginWithGoogle() async {
    try {} catch (exception) {
      authController.isLoading = false;
      showPopUp(
        title: AuthStrings.authFailure,
        message: exception.toString(),
        danger: true,
      );
    }
  }

  void _loginWithApple() async {
    try {} catch (exception) {
      authController.isLoading = false;
      showPopUp(
        title: AuthStrings.authFailure,
        message: exception.toString(),
        danger: true,
      );
    }
  }

  void _loginWithFacebook() async {
    try {
      await authController.loginWithFacebook().then(
        (success) {
          if (success) Get.toNamed(Routes.home);
        },
      );
    } catch (exception) {
      authController.isLoading = false;
      showPopUp(
        title: AuthStrings.authFailure,
        message: exception.toString(),
        danger: true,
      );
    }
  }
}
