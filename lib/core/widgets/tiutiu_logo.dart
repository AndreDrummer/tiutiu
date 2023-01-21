import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TiutiuLogo extends StatelessWidget {
  const TiutiuLogo({
    this.horizontal = false,
    this.spaceBetween,
    this.imageHeight,
    this.imageWidth,
    this.textHeight,
    this.textWidth,
    this.color,
    super.key,
  });

  final double? spaceBetween;
  final double? imageHeight;
  final double? textHeight;
  final double? imageWidth;
  final double? textWidth;
  final bool horizontal;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final components = [
      SizedBox(
        height: imageHeight ?? 28.0.h,
        width: imageWidth,
        child: Image.asset(
          color: color ?? AppColors.white,
          fit: BoxFit.fitHeight,
          ImageAssets.newLogo,
        ),
      ),
      SizedBox(
        height: horizontal ? 0.0 : spaceBetween ?? 8.0.h,
        width: horizontal ? spaceBetween ?? 8.0.w : 0.0,
      ),
      SizedBox(
        height: textHeight ?? 16.0.h,
        width: textWidth,
        child: Image.asset(
          color: color ?? AppColors.white,
          fit: BoxFit.fitHeight,
          ImageAssets.tiutiu,
        ),
      ),
    ];

    return horizontal
        ? Row(children: components)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: components,
          );
  }
}
