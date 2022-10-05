import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/images_assets.dart';

class PopUpMessage extends StatelessWidget {
  PopUpMessage({
    this.warning = false,
    this.denyText = '',
    this.error = false,
    this.confirmAction,
    this.confirmText,
    this.denyAction,
    this.message,
    this.title,
  });

  final void Function()? confirmAction;
  final void Function()? denyAction;
  final String? confirmText;
  final String denyText;
  final String? message;
  final String? title;
  final bool warning;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: error
          ? Color(0XFFDC3545)
          : warning
              ? Color(0XFFFFC107)
              : AppColors.primary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: TextStyle(color: AppColors.white, fontSize: 16.sp),
          ),
          SizedBox(
            height: 14.0.h,
            child: Image.asset(
              ImageAssets.newLogo,
            ),
          )
        ],
      ),
      content: Text(
        '$message',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.white,
          fontSize: 15,
        ),
      ),
      actions: <Widget>[
        confirmAction != null
            ? TextButton(
                onPressed: () => confirmAction?.call(),
                child: Text(
                  '$confirmText',
                  style: TextStyle(color: AppColors.white),
                ),
              )
            : Container(),
        denyAction != null
            ? TextButton(
                onPressed: () => denyAction?.call(),
                child: Text(
                  denyText,
                  style: TextStyle(color: AppColors.white),
                ),
              )
            : Container()
      ],
    );
  }
}
