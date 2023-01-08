import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/admob/admob_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({
    required this.adId,
    this.margin,
    super.key,
  });

  final EdgeInsetsGeometry? margin;
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
      Orientation.landscape,
      width: Get.width.toInt(),
      height: 56,
    );

    _bannerAd = BannerAd(
      listener: AdMobUtils.bannerAdListener(onAdLoaded: (ad) {
        debugPrint('TiuTiuApp: Banner Ad ${ad.adUnitId} Load.');
        _bannerAdFailedToLoad = false;
      }, onAdFailedToLoad: (ad, error) {
        debugPrint('TiuTiuApp: Banner Ad ${ad.adUnitId} Failed to load: $error');
        _bannerAdFailedToLoad = true;
      }),
      request: AdRequest(),
      adUnitId: widget.adId,
      size: size,
    );

    _bannerAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool allowGoogleAds = adminRemoteConfigController.configs.allowGoogleAds;

      bool isInAdoptOrFindBottomIndex = homeController.bottomBarIndex < 2;
      bool isInPostBottomIndex = homeController.bottomBarIndex == 2;
      bool userExists = authController.userExists;

      bool showAd = (userExists && !isInPostBottomIndex || (!userExists && isInAdoptOrFindBottomIndex)) &&
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
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
