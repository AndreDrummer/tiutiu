import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
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
          AutoSizeTexts.autoSizeText14(AppLocalizations.of(context)!.videoPlayerError, color: AppColors.white),
          SizedBox(height: 8.0.h),
          AutoSizeTexts.autoSizeText14(AppLocalizations.of(context)!.verifyInternetConnection, color: AppColors.white),
        ],
      ),
    );
  }
}
