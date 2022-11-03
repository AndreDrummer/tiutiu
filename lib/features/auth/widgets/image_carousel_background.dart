import 'package:tiutiu/features/system/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageCarouselBackground extends StatelessWidget {
  const ImageCarouselBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = authController.startScreenImages;

    return Container(
      alignment: Alignment.center,
      child: CarouselSlider.builder(
        itemCount: photos.length,
        itemBuilder: (ctx, index, _) {
          return Container(
            width: double.infinity,
            child: AssetHandle.getImage(
              photos.elementAt(index),
              fit: BoxFit.fitHeight,
            ),
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: photos.length > 1,
          autoPlayCurve: Curves.easeIn,
          enlargeCenterPage: true,
          viewportFraction: 1,
          height: Get.height,
          autoPlay: true,
        ),
      ),
    );
  }
}
