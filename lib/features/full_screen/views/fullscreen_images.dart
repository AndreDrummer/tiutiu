import 'package:tiutiu/features/system/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenImage extends StatelessWidget {
  FullScreenImage({
    this.photos,
  });

  final List? photos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0XFF000000),
      body: Obx(
        () => Center(
          child: CarouselSlider.builder(
            itemCount: photos?.length,
            itemBuilder: (ctx, index, i) {
              return GestureDetector(
                onScaleUpdate: (details) {
                  fullscreenController.zoom = details.scale;
                },
                child: Transform.scale(
                  scale: fullscreenController.zoom,
                  child: AssetHandle.getImage(
                    photos!.elementAt(index),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              enableInfiniteScroll: photos!.length > 1,
              height: 500 * fullscreenController.zoom,
              autoPlayCurve: Curves.easeIn,
              disableCenter: true,
              viewportFraction: 1,
              autoPlay: false,
            ),
          ),
        ),
      ),
    );
  }
}
