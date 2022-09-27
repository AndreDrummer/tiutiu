import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LoadDarkScreen extends StatelessWidget {
  LoadDarkScreen({
    this.message = 'Aguarde',
    this.show = true,
  });
  final String message;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingBumpingLine.circle(
                    backgroundColor: AppColors.white,
                  ),
                  SizedBox(height: 15),
                  AutoSizeText(
                    message,
                    style: TextStyles.fontSize12(color: AppColors.white),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
