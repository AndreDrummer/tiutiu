import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
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
          _backButton(context),
          _startButton(context),
        ],
      ),
      body: Stack(
        children: [
          ImageCarouselBackground(autoPlay: false),
          Blur(darker: true),
          Positioned(
            left: 16.0.w,
            top: 88.0.h,
            child: _header(context),
          ),
          Positioned(
            bottom: 164.0.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _warningLabel(context),
                _warningText(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _header(BuildContext context) {
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
                AppLocalizations.of(context).adoptionForm,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.left,
                color: AppColors.white,
              ),
              SizedBox(height: 8.0.h),
              SizedBox(
                width: Get.width * .85,
                child: AutoSizeTexts.autoSizeText16(
                  AppLocalizations.of(context).aboutForm,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4.0.h),
              SizedBox(
                width: Get.width * .85,
                child: AutoSizeTexts.autoSizeText16(
                  AppLocalizations.of(context).youDontNeedAnAccount,
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

  Padding _warningLabel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.0.w),
      child: AutoSizeTexts.autoSizeText16(
        AppLocalizations.of(context).note,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    );
  }

  Widget _warningText(BuildContext context) {
    return Container(
      width: Get.width * .9,
      margin: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeTexts.autoSizeText16(
            AppLocalizations.of(context).allQuestionsAreOptionals,
            color: AppColors.primary,
          ),
          SizedBox(height: 2.0.h),
          AutoSizeTexts.autoSizeText16(
            AppLocalizations.of(context).onlyAnwerWhatYouWant,
            fontWeight: FontWeight.w300,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }

  Widget _startButton(BuildContext context) {
    return _buttonButton(
      onPressed: () {
        Get.toNamed(Routes.whatToDoForm);
      },
      icon: Icons.keyboard_arrow_right_rounded,
      text: AppLocalizations.of(context).start,
    );
  }

  Widget _backButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0.w),
      child: _buttonButton(
        icon: Icons.keyboard_arrow_left_rounded,
        text: AppLocalizations.of(context).leave,
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
