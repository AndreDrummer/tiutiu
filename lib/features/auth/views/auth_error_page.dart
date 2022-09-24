import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/tiutiu_logo.dart';
import 'package:flutter/material.dart';

class AuthErrorPage extends StatelessWidget {
  const AuthErrorPage({
    Key? key,
    this.onErrorCallback,
    this.error,
  }) : super(key: key);

  final void Function()? onErrorCallback;
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
            TiutiuLogo(
              imageHeight: 28.0.h,
              textHeight: 16.0.h,
            ),
            Spacer(),
            Icon(
              color: AppColors.white,
              Icons.info,
              size: 24.0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0.h),
              child: AutoSizeText(
                AppStrings.genericError,
                textAlign: TextAlign.center,
                style: TextStyles.fontSize16(color: AppColors.white),
              ),
            ),
            Spacer(),
            TextButton.icon(
              icon: Icon(
                color: AppColors.white,
                Icons.exit_to_app,
                size: 14.0.h,
              ),
              label: AutoSizeText(
                AppStrings.leave,
                style: TextStyles.fontSize16(color: AppColors.white),
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
