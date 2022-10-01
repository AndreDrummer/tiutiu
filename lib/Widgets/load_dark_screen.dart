import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LoadDarkScreen extends StatelessWidget {
  LoadDarkScreen({
    this.message = 'Aguarde',
    this.visible = true,
  });
  final String message;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black87,
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
