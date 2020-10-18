import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'YOUR_DEVICE_ID';

class Ads {
  static BannerAd bannerAdTop;
  static BannerAd bannerAdTop2;
  static BannerAd bannerAdBottom;

  static void initialize() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['pets', 'cats' 'dogs', 'animais', 'gatos', 'cachorros'],
    childDirected: false,
  );

  static BannerAd _createBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-2837828701670824/9751920293',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  static InterstitialAd myInterstitial = InterstitialAd(    
    adUnitId: 'ca-app-pub-2837828701670824/9751920293',
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );

  static void showBannerAdTop() {
    if (bannerAdTop == null) bannerAdTop = _createBannerAd();
    bannerAdTop
      ..load()
      ..show(
        anchorOffset: 160,
        anchorType: AnchorType.top,
      );
  }

  static void showBannerAdTop2() {
    if (bannerAdTop2 == null) bannerAdTop2 = _createBannerAd();
    bannerAdTop2
      ..load()
      ..show(
        anchorOffset: 87,
        anchorType: AnchorType.top,
      );
  }

  static void hideBannerAdTop() async {
    await bannerAdTop.dispose();
    bannerAdTop = null;
  }

  static void hideBannerAdTop2() async {
    await bannerAdTop2.dispose();
    bannerAdTop2 = null;
  }

  static void showBannerAdBottom() {
    if (bannerAdBottom == null) bannerAdBottom = _createBannerAd();
    bannerAdBottom
      ..load()
      ..show(
        anchorOffset: 52,
        anchorType: AnchorType.bottom,
      );
  }

  static void hideBannerAdBottom() async {
    await bannerAdBottom.dispose();
    bannerAdBottom = null;
  }

  static void handleAdsBottom() {
    if (Ads.bannerAdTop != null || Ads.bannerAdTop2 != null) {
      Ads.hideBannerAdTop();
      Ads.hideBannerAdTop2();
    }
    Ads.showBannerAdBottom();
  }

  static void handleAdsTop() {
    if (Ads.bannerAdBottom != null) {
      Ads.hideBannerAdBottom();
      Ads.hideBannerAdTop2();
      
    }
    Ads.showBannerAdTop();
  }

  static void handleAdsTop2() {
    if (Ads.bannerAdBottom != null || Ads.bannerAdTop != null) {
      Ads.hideBannerAdBottom();
      Ads.hideBannerAdTop();
      
    }
    Ads.showBannerAdTop2();
  }
}
