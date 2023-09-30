import 'package:tiutiu/features/auth/widgets/image_carousel_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/auth/widgets/blur.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocScreen extends StatelessWidget {
  const DocScreen({super.key, required this.docText, required this.docTitle});

  final String docTitle;
  final String docText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageCarouselBackground(autoPlay: false),
          Blur(darker: true),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  children: [
                    SizedBox(height: 8.0.h),
                    TiutiuLogo(),
                    SizedBox(height: 16.0.h),
                    AutoSizeTexts.autoSizeText24(
                      textAlign: TextAlign.center,
                      color: AppColors.white,
                      docTitle,
                    ),
                    SizedBox(height: 16.0.h),
                    AutoSizeTexts.autoSizeText16(
                      docText.replaceAll('/n', '\n'),
                      textAlign: TextAlign.justify,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 64.0.h)
                  ],
                ),
                Positioned(
                  left: 0.0.w,
                  right: 0.0.w,
                  bottom: 0.0.h,
                  child: ButtonWide(
                    text: AppLocalizations.of(context)!.back,
                    onPressed: Get.back,
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
