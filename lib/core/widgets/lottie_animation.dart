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
      AnimationsAssets.pawsLoading,
      AnimationsAssets.walkWithDog,
      AnimationsAssets.birdLoading,
      AnimationsAssets.birdLoading,
      AnimationsAssets.catLoading,
      AnimationsAssets.dogLoading,
      AnimationsAssets.dogWalking,
    ];

    final path = animationPath ?? loadingAnimationsOptions.elementAt(Random().nextInt(loadingAnimationsOptions.length));

    return Lottie.asset(
      height: size ?? 96.0.h,
      width: size ?? 96.0.h,
      key: Key(path),
      animate: true,
      repeat: true,
      path,
    );
  }
}
