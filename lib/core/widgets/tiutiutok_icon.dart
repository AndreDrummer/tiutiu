import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TiutiutokIcon extends StatelessWidget {
  const TiutiutokIcon({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0.h,
      width: 20.0.h,
      child: Padding(
        child: Transform.rotate(
          child: AssetHandle.getImage(ImageAssets.playPaw, color: color),
          angle: 19.5 / pi,
        ),
        padding: const EdgeInsets.all(1.0),
      ),
    );
  }
}
