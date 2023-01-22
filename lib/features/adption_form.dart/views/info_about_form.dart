import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _backButton(),
          _startButton(),
        ],
      ),
      body: Stack(
        children: [
          ImageCarouselBackground(autoPlay: false),
          Blur(darker: true),
          Positioned(
            left: 16.0.w,
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
                _warningText(),
              ],
            ),
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
          padding: EdgeInsets.only(bottom: 2.0.h),
          child: Icon(Icons.list_alt_outlined, color: AppColors.white, size: 32.0.h),
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeTexts.autoSizeText32(
                AdoptionFormStrings.adoptionForm,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
                color: AppColors.white,
              ),
              SizedBox(height: 8.0.h),
              SizedBox(
                width: Get.width * .85,
                child: AutoSizeTexts.autoSizeText16(
                  AdoptionFormStrings.aboutForm,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4.0.h),
              SizedBox(
                width: Get.width * .85,
                child: AutoSizeTexts.autoSizeText16(
                  AdoptionFormStrings.youDontNeedAnAccount,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding _warningLabel() {
    return Padding(
      padding: EdgeInsets.only(left: 18.0.w),
      child: AutoSizeTexts.autoSizeText16(
        AdoptionFormStrings.note,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    );
  }

  Widget _warningText() {
    return Container(
      width: Get.width * .9,
      margin: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTexts.autoSizeText16(
            AdoptionFormStrings.allQuestionsAreOptionals,
            color: AppColors.primary,
          ),
          SizedBox(height: 2.0.h),
          AutoSizeTexts.autoSizeText16(
            AdoptionFormStrings.onlyAnwerWhatYouWant,
            fontWeight: FontWeight.w300,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _startButton() {
    return _buttonButton(
      onPressed: () async {
        final formExists = await adoptionFormController.formExists();

        Get.toNamed(formExists ? Routes.whatToDoForm : Routes.adoptionForm);
      },
      icon: Icons.keyboard_arrow_right_rounded,
      text: AdoptionFormStrings.start,
    );
  }

  Widget _backButton() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w),
      child: _buttonButton(
        icon: Icons.keyboard_arrow_left_rounded,
        text: AppStrings.back,
        onPressed: Get.back,
        iconOnRight: false,
      ),
    );
  }

  TextButton _buttonButton({
    required Function()? onPressed,
    bool iconOnRight = true,
    required IconData icon,
    required String text,
  }) {
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
          Visibility(visible: !iconOnRight, child: Icon(icon, color: AppColors.white)),
          AutoSizeTexts.autoSizeText16(text, color: AppColors.white),
          Visibility(visible: iconOnRight, child: Icon(icon, color: AppColors.white)),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
