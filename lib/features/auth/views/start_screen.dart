import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final photos = [
      StartScreenAssets.hasmterPink,
      StartScreenAssets.whiteCat,
      StartScreenAssets.pinscher,
      StartScreenAssets.hasmster,
      StartScreenAssets.munkun2,
      StartScreenAssets.munkun,
      StartScreenAssets.oldMel,
      StartScreenAssets.husky,
      StartScreenAssets.hairy,
    ];

    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: CarouselSlider.builder(
            itemCount: photos.length,
            itemBuilder: (ctx, index, i) {
              final randomNum = Random().nextInt(photos.length);
              return Container(
                width: double.infinity,
                child: AssetHandle.getImage(
                  photos.elementAt(randomNum),
                  fit: BoxFit.fitHeight,
                ),
              );
            },
            options: CarouselOptions(
              enableInfiniteScroll: photos.length > 1,
              autoPlayCurve: Curves.easeIn,
              viewportFraction: 1,
              height: Get.height,
              autoPlay: true,
            ),
          ),
        ),
        Container(
          color: Colors.black38,
          height: Get.height,
        ),
        Positioned(
          bottom: 8.0.h,
          right: 0.0.h,
          left: 0.0.h,
          child: Container(
            alignment: Alignment.center,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AutoSizeText(
                  'Faça Um Novo Amigo',
                  textAlign: TextAlign.center,
                  style: TextStyles.fontSize(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 32.0.sp,
                  ),
                ),
                SizedBox(height: 24.0.h),
                AutoSizeText(
                  'Muitos Lindos Pets estão aguardando por você',
                  textAlign: TextAlign.center,
                  style: TextStyles.fontSize(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontSize: 24.0.sp,
                  ),
                ),
                Spacer(),
                ButtonWide(
                  action: () {},
                  color: AppColors.primary,
                  text: 'Começar',
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16.0.h,
          right: 16.0.w,
          child: SizedBox(
            height: 56.0.h,
            child: Image.asset(
              ImageAssets.newLogo,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}
