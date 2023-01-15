import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SponsoredList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double sponsoredAdsTileSize = Dimensions.getDimensBasedOnDeviceHeight(
      bigger: 68.0.h,
      medium: 68.0.h,
      smaller: 80.0.h,
    );

    final sponsoreds = sponsoredController.sponsoreds;

    final visible = adminRemoteConfigController.configs.showSponsoredAds &&
        systemController.properties.internetConnected &&
        sponsoreds.isNotEmpty;

    return Visibility(
      visible: visible,
      child: CarouselSlider.builder(
        itemCount: sponsoreds.length,
        itemBuilder: (context, index, realIndex) {
          final sponsored = sponsoreds[index];

          return GestureDetector(
            onTap: () {
              Launcher.openBrowser(sponsored.link!);
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.h)),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0.h)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0.h),
                  child: AssetHandle.getImage(sponsored.imagePath),
                ),
                alignment: Alignment.center,
                width: Get.width,
              ),
              margin: EdgeInsets.only(top: 4.0.h),
            ),
          );
        },
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
