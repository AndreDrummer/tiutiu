import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DisappearedTag extends StatelessWidget {
  const DisappearedTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 16.0.h,
      width: 72.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8.0.h),
          bottomLeft: Radius.circular(8.0.h),
          topRight: Radius.circular(12.0.h),
        ),
        color: Colors.orange,
      ),
      child: AutoSizeTexts.autoSizeText10(
        AppLocalizations.of(context)!.disappeared,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    );
  }
}
