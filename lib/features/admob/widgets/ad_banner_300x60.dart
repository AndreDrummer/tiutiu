import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdBanner300x60 extends StatefulWidget {
  const AdBanner300x60({
    this.borderRadius = BorderRadius.zero,
    required this.adBlockName,
    super.key,
  });

  final BorderRadiusGeometry? borderRadius;
  final String adBlockName;

  @override
  State<AdBanner300x60> createState() => _AdBanner300x60State();
}

class _AdBanner300x60State extends State<AdBanner300x60> {
  @override
  void initState() {
    final blockID = systemController.getAdMobBlockID(blockName: widget.adBlockName, type: AdMobType.banner);
    adMobController.updateBannerAdId(blockID);
    adMobController.bannerAd.load();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !adMobController.bannerAdFailedToLoad,
      child: Container(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          child: AdWidget(ad: adMobController.bannerAd),
          borderRadius: widget.borderRadius,
        ),
        width: Get.width,
        height: Dimensions.isBigDevice() ? 48.0.h : 56.0.h,
      ),
    );
  }

  @override
  void dispose() {
    adMobController.bannerAd.dispose();
    super.dispose();
  }
}
