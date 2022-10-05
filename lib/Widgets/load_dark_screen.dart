import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LoadDarkScreen extends StatelessWidget {
  LoadDarkScreen({
    this.roundeCorners = false,
    this.message = 'Aguarde',
    this.visible = true,
  });
  final bool roundeCorners;
  final String message;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              roundeCorners ? 12.0.h : 0.0,
            ),
          ),
          color: Colors.black87,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingFadingLine.circle(
                backgroundColor: AppColors.secondary,
              ),
              SizedBox(height: 15),
              AutoSizeText(
                message,
                style: TextStyles.fontSize12(color: AppColors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
