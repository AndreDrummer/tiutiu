import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/text_styles.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({
    this.messageLoading = 'Carregando aplicativo...',
    this.circle = false,
    this.textColor,
  });

  final String messageLoading;
  final Color? textColor;
  final bool circle;

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  // AdsProvider adsProvider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          !widget.circle
              ? LoadingRotating.square(
                  size: 40.0,
                  borderColor: AppColors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : LoadingJumpingLine.circle(
                  size: 40.0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
          SizedBox(height: 30.0),
          AutoSizeText(
            widget.messageLoading,
            textAlign: TextAlign.center,
            style: TextStyles.fontSize12(
              color: widget.textColor ?? AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}
