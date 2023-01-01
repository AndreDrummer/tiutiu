import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

final BannerAdListener _bannerAdlistener = BannerAdListener(
  // Called when an ad is successfully received.
  onAdLoaded: (Ad ad) => debugPrint('<> Ad loaded.'),
  // Called when an ad request failed.
  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    // Dispose the ad here to free resources.
    ad.dispose();
    debugPrint('<> Ad failed to load: $error');
  },
  // Called when an ad opens an overlay that covers the screen.
  onAdOpened: (Ad ad) => debugPrint('<> Ad opened.'),
  // Called when an ad removes an overlay that covers the screen.
  onAdClosed: (Ad ad) => debugPrint('<> Ad closed.'),
  // Called when an impression occurs on the ad.
  onAdImpression: (Ad ad) => debugPrint('<> Ad impression.'),
);

class AdMobController extends GetxController {
  final RxBool _interstitialAdWasLoaded = false.obs;
  bool _rewardedAdWasLoaded = false;

  final Rx<BannerAd> _bannerAd = BannerAd(
    listener: _bannerAdlistener,
    request: AdRequest(),
    size: AdSize.banner,
    adUnitId: '',
  ).obs;

  late InterstitialAd _interstitialAd;
  late RewardedAd _rewardedAd;

  bool get interstitialAdWasLoaded => _interstitialAdWasLoaded.value;
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

  int minutesFreeOfRewardedAd(ContactType contactType) {
    if (contactType == ContactType.whatsapp) return 2;
    return 10;
  }

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: appController.getAdMobBlockID(blockName: AdMobBlockName.whatsaAppNumber, type: AdMobType.rewarded),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          this._rewardedAd = ad;
          _rewardedAdWasLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  Future<void> showRewardedAd(ContactType contactType) async {
    if (!_rewardedAdWasLoaded) {
      await loadRewardedAd();
    }

    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (RewardedAd ad) => debugPrint('$ad impression occurred.'),
    );

    _rewardedAd.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
        ad.dispose();
        debugPrint('Usuário assistiu certinho ${ad.adUnitId} ${rewardItem.amount}');

        await LocalStorage.setValueUnderLocalStorageKey(
          key: contactType == ContactType.whatsapp
              ? LocalStorageKey.lastTimeWatchedWhatsappRewarded
              : LocalStorageKey.lastTimeWatchedChatRewarded,
          value: DateTime.now().toIso8601String(),
        );
      },
    );
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: appController.getAdMobBlockID(blockName: AdMobBlockName.onAppOpening, type: AdMobType.interstitial),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this._interstitialAd = ad;
          _interstitialAdWasLoaded(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );

    if (interstitialAdWasLoaded) {
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) => debugPrint('%ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) async {
          debugPrint('$ad onAdDismissedFullScreenContent.');

          await LocalStorage.setValueUnderLocalStorageKey(
            key: LocalStorageKey.lastTimeSeenAnIntertitial,
            value: DateTime.now().toIso8601String(),
          );
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (InterstitialAd ad) => debugPrint('$ad impression occurred.'),
      );
    }
  }

  Future<void> showInterstitialAd() async {
    if (!interstitialAdWasLoaded) {
      await loadInterstitialAd();
    } else {
      _interstitialAd.show();
      _interstitialAd.dispose();
      _interstitialAdWasLoaded(false);
    }
  }
}
