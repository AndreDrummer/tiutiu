import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class LoadingVideo extends StatelessWidget {
  const LoadingVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieAnimation(animationPath: AnimationsAssets.pawLoading2, size: 48),
        SizedBox(height: 8.0.h),
        AutoSizeTexts.autoSizeText14(
          AppStrings.loadingVideo,
          color: AppColors.white,
        ),
      ],
    );
  }
}
