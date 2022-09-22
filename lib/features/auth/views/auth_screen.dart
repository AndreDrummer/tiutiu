import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final photos = [
      // 'assets/bones.webp'
      // 'assets/auth_images/husky-filhote.webp',
      // 'assets/auth_images/hamster-rosa.webp',
      'assets/auth_images/branquinha.webp',
      // 'assets/auth_images/pinscher.webp',
      // 'assets/auth_images/hamster.webp',
      // 'assets/auth_images/mel.webp',
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: CarouselSlider.builder(
          itemCount: photos.length,
          itemBuilder: (ctx, index, i) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Container(
                width: double.infinity,
                child: AssetHandle.getImage(photos.elementAt(index)),
              ),
            );
          },
          options: CarouselOptions(
            enableInfiniteScroll: photos.length > 1,
            autoPlayCurve: Curves.easeIn,
            disableCenter: true,
            viewportFraction: 1,
            autoPlay: true,
          ),
        ),
      ),
    );
  }
}
