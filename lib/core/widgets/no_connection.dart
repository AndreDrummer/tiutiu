import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImageAssets.noConnection), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
