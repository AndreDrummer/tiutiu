import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/tiutiu_logo.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.onErrorCallback,
    this.errorMessage,
    this.error,
    super.key,
  });

  final void Function()? onErrorCallback;
  final String? errorMessage;
  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            TiutiuLogo(),
            Spacer(),
            Icon(
              color: AppColors.white,
              Icons.info,
              size: 24.0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0.h),
              child: AutoSizeTexts.autoSizeText16(
                errorMessage ?? error.toString(),
                textAlign: TextAlign.center,
                color: AppColors.white,
              ),
            ),
            Spacer(),
            TextButton.icon(
              icon: Icon(
                color: AppColors.white,
                Icons.exit_to_app,
                size: 14.0.h,
              ),
              label: AutoSizeTexts.autoSizeText16(
                color: AppColors.white,
                AppStrings.leave,
              ),
              onPressed: onErrorCallback,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
