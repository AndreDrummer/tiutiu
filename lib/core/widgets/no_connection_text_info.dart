import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NoConnectionTextInfo extends StatelessWidget {
  const NoConnectionTextInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeTexts.autoSizeText12(
            AppLocalizations.of(context)!.noConnection,
            color: AppColors.danger,
          ),
          Padding(
            padding: EdgeInsets.only(left: 2.0.w, bottom: 2.0.h),
            child: Icon(
              color: AppColors.danger,
              Icons.wifi_off,
              size: 14,
            ),
          )
        ],
      ),
    );
  }
}
