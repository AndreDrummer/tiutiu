import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

class ButtonWide extends StatelessWidget {
  ButtonWide({
    this.isToExpand = false,
    this.rounded = true,
    this.action,
    this.color,
    this.icon,
    this.text,
  });

  final bool? isToExpand;
  final Function? action;
  final IconData? icon;
  final bool? rounded;
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action?.call(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 8.0.w),
        alignment: Alignment.center,
        height: 48.0.h,
        width: isToExpand! ? Get.width : 260.0.w,
        decoration: BoxDecoration(
          borderRadius: rounded == true ? BorderRadius.circular(12) : null,
          color: color ?? AppColors.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Icon(icon, size: 20, color: Colors.white)
                  : AutoSizeText(''),
              icon != null ? SizedBox(width: 15) : AutoSizeText(''),
              AutoSizeText(
                text!,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
