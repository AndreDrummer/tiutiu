import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({
    this.animationPath,
    this.size,
    super.key,
  });

  final String? animationPath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final loadingAnimationsOptions = [
      AnimationsAssets.birdLoading,
      AnimationsAssets.catLoading,
      AnimationsAssets.dogLoading,
      AnimationsAssets.dogWalking,
      AnimationsAssets.pawLoading,
    ];

    return Lottie.asset(
      animationPath ?? loadingAnimationsOptions.elementAt(Random().nextInt(4)),
      height: size ?? 96.0.h,
      animate: true,
      repeat: true,
      width: size,
    );
  }
}
