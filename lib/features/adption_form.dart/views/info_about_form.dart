import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoAboutForm extends StatelessWidget {
  const InfoAboutForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: _startButton(),
      body: Stack(
        children: [
          ImageCarouselBackground(autoPlay: false),
          Blur(darker: true),
          Positioned(
            left: 32.0.w,
            top: 88.0.h,
            child: _header(),
          ),
          Positioned(
            bottom: 164.0.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _warningLabel(),
                SizedBox(height: 8.0.h),
                _warningText(),
              ],
            ),
          ),
          Positioned(
            right: 24.0.w,
            top: Get.width,
            child: LottieAnimation(animationPath: AnimationsAssets.alert, size: 64.0.h),
          ),
        ],
      ),
    );
  }

  Column _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0.h),
          child: Icon(Icons.list_alt_outlined, color: AppColors.white, size: 32.0.h),
        ),
        AutoSizeTexts.autoSizeText24(
          AdoptionFormStrings.adoptionForm,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.left,
          color: AppColors.white,
        ),
        SizedBox(height: 8.0.h),
        SizedBox(
          width: Get.width * .8,
          child: AutoSizeTexts.autoSizeText12(
            AdoptionFormStrings.aboutForm,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left,
            color: AppColors.white,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Padding _warningLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 32.0.w),
      child: AutoSizeTexts.autoSizeText16(
        AppStrings.warning,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary,
      ),
    );
  }

  Widget _warningText() {
    return Container(
      width: Get.width * .9,
      margin: EdgeInsets.symmetric(horizontal: 32.0.w, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTexts.autoSizeText12(
            AdoptionFormStrings.allQuestionsAreOptionals,
            color: AppColors.primary,
          ),
          SizedBox(height: 8.0.h),
          AutoSizeTexts.autoSizeText12(
            AdoptionFormStrings.onlyAnwerWhatYouWant,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  TextButton _startButton() {
    return TextButton(
      style: TextButton.styleFrom(
        splashFactory: InkRipple.splashFactory,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AutoSizeTexts.autoSizeText14(
            AdoptionFormStrings.start,
            color: AppColors.white,
          ),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: AppColors.white,
          ),
        ],
      ),
      onPressed: () {
        Get.toNamed(Routes.adoptionForm);
      },
    );
  }
}
