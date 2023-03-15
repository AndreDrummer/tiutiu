import 'package:tiutiu/features/sponsored/widget/sponsodred_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SponsoredHorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double sponsoredAdsTileSize = Dimensions.getDimensBasedOnDeviceHeight(
      smaller: 80.0.h,
      bigger: 68.0.h,
      medium: 68.0.h,
      tablet: 80.0.h,
    );

    final sponsoreds = sponsoredController.sponsoreds;

    final visible = adminRemoteConfigController.configs.showSponsoredAds &&
        systemController.properties.internetConnected &&
        sponsoreds.isNotEmpty;

    return Visibility(
      visible: visible,
      child: CarouselSlider.builder(
        itemCount: sponsoreds.length,
        itemBuilder: (context, index, realIndex) => SponsoredTile(sponsored: sponsoreds[index]),
        options: CarouselOptions(
          enableInfiniteScroll: sponsoreds.length > 1,
          autoPlayCurve: Curves.easeIn,
          height: sponsoredAdsTileSize,
          enlargeCenterPage: true,
          viewportFraction: 1,
          autoPlay: true,
        ),
      ),
    );
  }
}
