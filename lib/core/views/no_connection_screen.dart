import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieAnimation(
              animationPath: AnimationsAssets.noInternet,
              size: 120.0.h,
            ),
            SizedBox(height: 16.0.h),
            AutoSizeTexts.autoSizeText14(
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
              AppStrings.noConnection,
            )
          ],
        ),
      ),
    );
  }
}
