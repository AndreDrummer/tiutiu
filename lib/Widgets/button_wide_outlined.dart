import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ButtonWideOutlined extends StatelessWidget {
  ButtonWideOutlined({
    this.isToExpand = false,
    this.rounded = true,
    this.textIconColor,
    this.action,
    this.color,
    this.icon,
    this.text,
  });

  final Color? textIconColor;
  final Function? action;
  final bool isToExpand;
  final IconData? icon;
  final String? text;
  final Color? color;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: color ?? AppColors.secondary,
            style: BorderStyle.solid,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              rounded ? 24.0.h : 8.0.h,
            ),
          ),
        ),
        onPressed: () => action?.call(),
        child: Container(
          alignment: Alignment.center,
          height: 48.0.h,
          child: Row(
            mainAxisAlignment:
                hasIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Visibility(
                visible: hasIcon,
                child: Icon(
                  color: textIconColor ?? AppColors.white,
                  size: 20.0.h,
                  icon,
                ),
              ),
              Spacer(),
              AutoSizeText(
                text ?? AppStrings.getStarted,
                textAlign: TextAlign.center,
                style: TextStyles.fontSize16(
                  color: color ?? AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
