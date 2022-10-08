import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    required this.onCancel,
    this.textColor,
    this.text,
    super.key,
  });

  final Function() onCancel;
  final Color? textColor;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
      child: OneLineText(
        color: textColor ?? AppColors.white,
        text: text ?? AppStrings.cancel,
        alignment: Alignment.center,
        fontWeight: FontWeight.bold,
        fontSize: 16.0.sp,
      ),
      onPressed: () {
        onCancel();
      },
    );
  }
}
