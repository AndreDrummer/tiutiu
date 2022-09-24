import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({
    this.messageLoading = 'Carregando',
    this.circle = false,
    this.textColor,
  });

  final String messageLoading;
  final Color? textColor;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingFadingLine.circle(
              backgroundColor: Theme.of(context).primaryColor,
              size: 32.0.h,
            ),
            SizedBox(height: 8.0.h),
            AutoSizeText(
              messageLoading,
              textAlign: TextAlign.center,
              style: TextStyles.fontSize12(
                color: textColor ?? AppColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
