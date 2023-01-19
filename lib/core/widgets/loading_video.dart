import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:flutter/material.dart';

class LoadingVideo extends StatelessWidget {
  const LoadingVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      child: LottieAnimation(
        animationPath: AnimationsAssets.loadingWifi,
        size: 32,
      ),
      opacity: .6,
    );
  }
}
