import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class VideoError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.triangleExclamation, color: AppColors.white),
          SizedBox(height: 4.0.h),
          AutoSizeTexts.autoSizeText14(PostDetailsStrings.videoPlayerError, color: AppColors.white),
          SizedBox(height: 8.0.h),
          AutoSizeTexts.autoSizeText14(AppStrings.verifyInternetConnection, color: AppColors.white),
        ],
      ),
    );
  }
}
