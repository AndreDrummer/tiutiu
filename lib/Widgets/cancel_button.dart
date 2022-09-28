import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    required this.onCancel,
    super.key,
  });

  final Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
      child: OneLineText(
        alignment: Alignment.center,
        fontWeight: FontWeight.bold,
        text: AppStrings.cancel,
        color: AppColors.white,
        fontSize: 16.0.sp,
      ),
      onPressed: () {
        onCancel();
      },
    );
  }
}
