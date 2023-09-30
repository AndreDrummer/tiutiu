import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HintError extends StatelessWidget {
  HintError({this.message});

  final message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-1, 1),
      child: Padding(
        padding: EdgeInsets.only(top: 8.0.h),
        child: AutoSizeText(
          message ?? AppLocalizations.of(context)!.requiredField,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.danger,
          ),
          maxFontSize: 13,
        ),
      ),
    );
  }
}
