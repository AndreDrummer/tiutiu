import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({
    this.messageLoading,
    this.textColor,
  });

  final String? messageLoading;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieAnimation(),
            SizedBox(height: 8.0.h),
            AutoSizeTexts.autoSizeText12(
              color: textColor ?? AppColors.white,
              textAlign: TextAlign.center,
              messageLoading ?? AppLocalizations.of(context)!.wait,
            )
          ],
        ),
      ),
    );
  }
}
