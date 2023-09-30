import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWide extends StatelessWidget {
  ButtonWide({
    this.isToExpand = false,
    this.isLoading = false,
    this.rounded = true,
    this.tiny = false,
    this.onPressed,
    this.textColor,
    this.fontSize,
    this.iconSize,
    this.padding,
    this.color,
    this.icon,
    this.text,
  });

  final EdgeInsetsGeometry? padding;
  final Function? onPressed;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final bool isToExpand;
  final bool isLoading;
  final IconData? icon;
  final String? text;
  final Color? color;
  final bool rounded;
  final bool tiny;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 4.0.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rounded ? 24.0.h : 8.0.h)),
          backgroundColor: color ?? AppColors.primary,
        ),
        onPressed: () => onPressed?.call(),
        child: Container(
          child: isLoading ? _loadingWidget() : _content(context),
          width: isToExpand ? Get.width : 260.0.w,
          height: tiny ? 32.0.h : 48.0.h,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final hasIcon = icon != null;

    return Row(
      mainAxisAlignment: hasIcon ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Visibility(
          visible: hasIcon,
          child: Icon(
            color: textColor ?? AppColors.white,
            size: iconSize ?? 20.0.h,
            icon,
          ),
        ),
        Spacer(),
        AutoSizeTexts.autoSizeText(
          color: textColor ?? AppColors.white,
          text ?? AppLocalizations.of(context)!.getStarted,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          fontSize: fontSize ?? 16,
        ),
        Spacer(),
        Visibility(
          visible: hasIcon,
          child: SizedBox(width: isToExpand ? 20.0.w : 0.0),
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return SizedBox(
      child: CircularProgressIndicator(
        color: AppColors.white,
      ),
    );
  }
}
