import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class ImageCarouselBackground extends StatelessWidget {
  const ImageCarouselBackground({this.autoPlay = true, super.key});

  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    final photos = authController.startScreenImages;
    late int randomIndex;

    return Container(
      alignment: Alignment.center,
      child: CarouselSlider.builder(
        itemCount: photos.length,
        itemBuilder: (ctx, index, _) {
          if (autoPlay) {
            randomIndex = index;
          } else {
            randomIndex = Random().nextInt(photos.length);
          }
          return Container(
            width: double.infinity,
            child: AssetHandle.getImage(
              photos.elementAt(randomIndex),
              fit: BoxFit.cover,
            ),
          );
        },
        options: CarouselOptions(
          enableInfiniteScroll: photos.length > 1,
          autoPlayCurve: Curves.easeIn,
          enlargeCenterPage: true,
          viewportFraction: 1,
          height: Get.height,
          autoPlay: autoPlay,
        ),
      ),
    );
  }
}
