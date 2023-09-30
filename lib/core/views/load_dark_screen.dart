import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadDarkScreen extends StatelessWidget {
  LoadDarkScreen({
    this.roundeCorners = false,
    this.visible = true,
    this.message,
  });
  final bool roundeCorners;
  final String? message;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                roundeCorners ? 12.0.h : 0.0,
              ),
            ),
            color: Colors.black87,
          ),
          height: Get.height,
          width: Get.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieAnimation(),
                SizedBox(height: 15),
                AutoSizeTexts.autoSizeText12(
                  textAlign: TextAlign.center,
                  color: AppColors.white,
                  message ?? AppLocalizations.of(Get.context!)!.wait,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
