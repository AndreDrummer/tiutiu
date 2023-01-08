import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobUtils {
  static final BannerAd defaultBannerAd = BannerAd(
    listener: BannerAdListener(),
    request: AdRequest(),
    size: AdSize.banner,
    adUnitId: '',
  );

  static BannerAdListener bannerAdListener({
    void Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
    void Function(Ad)? onAdImpression,
    void Function(Ad)? onAdOpened,
    void Function(Ad)? onAdClosed,
    void Function(Ad)? onAdLoaded,
  }) {
    return BannerAdListener(
      onAdFailedToLoad: onAdFailedToLoad,
      onAdImpression: onAdImpression,
      onAdLoaded: onAdLoaded,
      onAdOpened: onAdOpened,
      onAdClosed: onAdClosed,
    );
  }
}
