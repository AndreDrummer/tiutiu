import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:flutter/material.dart';

class TiutiuLogo extends StatelessWidget {
  const TiutiuLogo({
    super.key,
    required this.imageHeight,
    required this.textHeight,
    this.horizontal = false,
    this.imageWidth,
    this.textWidth,
  });

  final double imageHeight;
  final double? imageWidth;
  final double textHeight;
  final double? textWidth;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final components = [
      SizedBox(
        height: imageHeight,
        width: imageWidth,
        child: Image.asset(
          ImageAssets.newLogo,
          fit: BoxFit.fitHeight,
        ),
      ),
      SizedBox(
        height: horizontal ? 0.0 : 8.0.h,
        width: horizontal ? 8.0.w : 0.0,
      ),
      SizedBox(
        height: textHeight,
        width: textWidth,
        child: Image.asset(
          ImageAssets.tiutiu,
          fit: BoxFit.fitHeight,
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
