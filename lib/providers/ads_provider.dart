import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AdsProvider with ChangeNotifier {
  // Streams
  final _canShowAds = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get canShowAds => _canShowAds.stream;  
  void Function(bool) get changeCanShowAds => _canShowAds.sink.add;  
  bool get getCanShowAds => _canShowAds.value;

  String get homeAdId => 'ca-app-pub-2837828701670824/9751920293';
  String get bottomAdId => 'ca-app-pub-2837828701670824/5937594529';
  String get topAdId => 'ca-app-pub-2837828701670824/3311431180';
  String get intertitialAdId => 'ca-app-pub-2837828701670824/9030661721';
  
  
  
  int bannerWidth = 300;
  void changeBannerWidth(int width) {
    bannerWidth = width;
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        // showDialog();
        break;
      default:
    }
  }

  AdmobBanner bannerAdMob({String adId, bool medium_banner = false, bool testeAdId = false}) {
    return AdmobBanner(
      adUnitId: !testeAdId ? adId : BannerAd.testAdUnitId,
      adSize: medium_banner?  AdmobBannerSize.MEDIUM_RECTANGLE : AdmobBannerSize.ADAPTIVE_BANNER(width: bannerWidth),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Banner');
      },
      onBannerCreated: (AdmobBannerController controller) {
        // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
        // Normally you don't need to worry about disposing this yourself, it's handled.
        // If you need direct access to dispose, this is your guy!
        // controller.dispose();
      },
    );
  }

  AdmobReward _createAdmobReward() {
    return AdmobReward(
      adUnitId: 'ca-app-pub-2837828701670824/2607997257',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) getRewardAd.load();
      },
    );
  }

  final _rewardAd = BehaviorSubject<AdmobReward>();

  Stream<AdmobReward> get rewardAd => _rewardAd.stream;
  void Function(AdmobReward) get changeRewardAd => _rewardAd.sink.add;
  AdmobReward get getRewardAd => _rewardAd.value;

  void initReward() {
    changeRewardAd(_createAdmobReward());    
  }

  @override
  void dispose() {
    getRewardAd.dispose();
    super.dispose();
  }
}
