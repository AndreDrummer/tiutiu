import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PopUpMessage extends StatelessWidget {
  PopUpMessage({
    this.backGroundColor,
    this.denyText = '',
    this.confirmAction,
    this.confirmText,
    this.denyAction,
    this.textColor,
    this.message,
    this.title,
  });

  final void Function()? confirmAction;
  final void Function()? denyAction;
  final Color? backGroundColor;
  final String? confirmText;
  final Color? textColor;
  final String denyText;
  final String? message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backGroundColor ?? AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: TextStyle(color: textColor ?? AppColors.white, fontSize: 16),
          ),
          SizedBox(
            height: 14.0.h,
            child: Image.asset(
              ImageAssets.newLogo,
              color: textColor,
            ),
          )
        ],
      ),
      content: Text(
        '$message',
        style: TextStyle(
          color: textColor ?? AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      actions: <Widget>[
        confirmAction != null
            ? TextButton(
                onPressed: () => confirmAction?.call(),
                child: Text(
                  '$confirmText',
                  style: TextStyle(color: textColor ?? AppColors.white),
                ),
              )
            : Container(),
        denyAction != null
            ? TextButton(
                onPressed: () => denyAction?.call(),
                child: Text(
                  denyText,
                  style: TextStyle(color: textColor ?? AppColors.white),
                ),
              )
            : Container()
      ],
    );
  }
}
