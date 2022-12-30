import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class LoadingVideo extends StatelessWidget {
  const LoadingVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          AutoSizeTexts.autoSizeText12(
            PostDetailsStrings.loadingVideoFirstTime,
            textAlign: TextAlign.center,
            color: AppColors.white,
          ),
          SizedBox(height: 16.0.h),
          SizedBox(child: CircularProgressIndicator(), height: 16.0.h, width: 16.0.w),
          Spacer(),
        ],
      ),
    );
  }
}
