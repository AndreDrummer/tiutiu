import 'dart:io';

import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/admob/admob_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({
    required this.adId,
    this.height,
    this.margin,
    super.key,
  });

  final EdgeInsetsGeometry? margin;
  final int? height;
  final String adId;

  @override
  State<AdBanner> createState() => _AdBanner300x60State();
}

class _AdBanner300x60State extends State<AdBanner> {
  bool _bannerAdFailedToLoad = false;
  late BannerAd _bannerAd;

  @override
  void initState() {
    final size = AnchoredAdaptiveBannerAdSize(
      height: widget.height ?? 56,
      width: Get.width.toInt(),
      Orientation.landscape,
    );

    if (Platform.isAndroid || Platform.isIOS) {
      _bannerAd = BannerAd(
        listener: AdMobUtils.bannerAdListener(onAdLoaded: (ad) {
          if (kDebugMode)
            debugPrint('TiuTiuApp: Banner Ad ${ad.adUnitId} Load.');
          _bannerAdFailedToLoad = false;
        }, onAdFailedToLoad: (ad, error) {
          if (kDebugMode)
            debugPrint(
                'TiuTiuApp: Banner Ad ${ad.adUnitId} Failed to load: $error');
          _bannerAdFailedToLoad = true;
        }),
        request: AdRequest(),
        adUnitId: widget.adId,
        size: size,
      );

      _bannerAd.load();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Obx(() {
        bool allowGoogleAds =
            adminRemoteConfigController.configs.allowGoogleAds;

        bool isInAdoptBottomIndex =
            homeController.bottomBarIndex == BottomBarIndex.DONATE.index;
        bool isInFindBottomIndex =
            homeController.bottomBarIndex == BottomBarIndex.FINDER.index;
        bool isInPostBottomIndex =
            homeController.bottomBarIndex == BottomBarIndex.POST.indx;
        bool userExists = authController.userExists;

        bool showAd = (userExists && !isInPostBottomIndex ||
                (!userExists &&
                    (isInAdoptBottomIndex || isInFindBottomIndex))) &&
            (!_bannerAdFailedToLoad && allowGoogleAds);
        return Visibility(
          child: Container(
            margin: widget.margin ?? EdgeInsets.zero,
            height: _bannerAd.size.height.toDouble(),
            width: _bannerAd.size.width.toDouble(),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: AdWidget(ad: _bannerAd),
            ),
          ),
          visible: showAd,
        );
      });
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid || Platform.isIOS) {
      _bannerAd.dispose();
    }
    super.dispose();
  }
}
