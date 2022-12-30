import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

final BannerAdListener _bannerAdlistener = BannerAdListener(
  // Called when an ad is successfully received.
  onAdLoaded: (Ad ad) => print('<> Ad loaded.'),
  // Called when an ad request failed.
  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    // Dispose the ad here to free resources.
    ad.dispose();
    print('<> Ad failed to load: $error');
  },
  // Called when an ad opens an overlay that covers the screen.
  onAdOpened: (Ad ad) => print('<> Ad opened.'),
  // Called when an ad removes an overlay that covers the screen.
  onAdClosed: (Ad ad) => print('<> Ad closed.'),
  // Called when an impression occurs on the ad.
  onAdImpression: (Ad ad) => print('<> Ad impression.'),
);

class AdMobController extends GetxController {
  final Rx<BannerAd> _bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    listener: _bannerAdlistener,
    request: AdRequest(),
    size: AdSize.banner,
  ).obs;

  BannerAd get bannerAd => _bannerAd.value;

  void updateBannerAdId(String adId) {
    bannerAd.dispose();

    _bannerAd(
      BannerAd(
        listener: _bannerAdlistener,
        request: AdRequest(),
        size: AdSize.banner,
        adUnitId: adId,
      ),
    );
  }

  void disposeAllAds() {
    bannerAd.dispose();
  }
}
