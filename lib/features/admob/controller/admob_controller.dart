import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';

class AdMobController extends GetxController {
  final RxBool _interstitialAdWasLoaded = false.obs;
  final RxBool _bannerAdFailedToLoad = false.obs;
  bool _rewardedAdWasLoaded = false;

  final Rx<BannerAd> _bannerAd = BannerAd(
    listener: BannerAdListener(),
    request: AdRequest(),
    size: AdSize.banner,
    adUnitId: '',
  ).obs;

  late InterstitialAd _interstitialAd;
  late RewardedAd _rewardedAd;

  bool get interstitialAdWasLoaded => _interstitialAdWasLoaded.value;
  bool get bannerAdFailedToLoad => _bannerAdFailedToLoad.value;
  BannerAd get bannerAd => _bannerAd.value;

  void updateBannerAdId(String adId) {
    bannerAd.dispose();

    _bannerAd(
      BannerAd(
        listener: _bannerAdlistener(),
        request: AdRequest(),
        size: AdSize.banner,
        adUnitId: adId,
      ),
    );
  }

  BannerAdListener _bannerAdlistener() {
    return BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        _bannerAdFailedToLoad(false);
        debugPrint('<> BannerAd loaded.');
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        _bannerAdFailedToLoad(true);
        ad.dispose();
        debugPrint('<> BannerAd failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => debugPrint('<> BannerAd opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => debugPrint('<> BannerAd closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => debugPrint('<> BannerAd impression.'),
    );
  }

  int minutesFreeOfRewardedAd(ContactType contactType) {
    if (contactType == ContactType.whatsapp) return 2;
    return 10;
  }

  Future<void> loadWhatsAppRewardedAd() async {
    await _loadRewardedAd(AdMobBlockName.whatsappQuoteAdBlockId);
  }

  Future<void> loadChatRewardedAd() async {
    await _loadRewardedAd(AdMobBlockName.chatQuoteAdBlockId);
  }

  Future<void> _loadRewardedAd(String adBlockName) async {
    await RewardedAd.load(
      adUnitId: appController.getAdMobBlockID(
        type: AdMobType.rewarded,
        blockName: adBlockName,
      ),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('RewardedAd $ad loaded.');
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
      contactType == ContactType.whatsapp ? await loadWhatsAppRewardedAd() : await loadChatRewardedAd();
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
        debugPrint('TiuTiuApp: Usuário assistiu certinho ${ad.adUnitId} ${rewardItem.amount}');

        await LocalStorage.setValueUnderLocalStorageKey(
          key: contactType == ContactType.whatsapp
              ? LocalStorageKey.lastTimeWatchedWhatsappRewarded
              : LocalStorageKey.lastTimeWatchedChatRewarded,
          value: DateTime.now().toIso8601String(),
        );
      },
    ).then((_) => _rewardedAdWasLoaded = false);
  }

  Future<void> loadOpeningAd() async {
    final String androidIntertitialAdId = 'ca-app-pub-6457225629935762/1316775501';
    final String iOSIntertitialAdId = 'ca-app-pub-6457225629935762/4903299747';
    final String adTestId = 'ca-app-pub-3940256099942544/4411468910';
    final bool isIOS = Platform.isIOS;

    final String prodAdId = isIOS ? iOSIntertitialAdId : androidIntertitialAdId;

    await InterstitialAd.load(
      adUnitId: kDebugMode ? adTestId : prodAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          this._interstitialAd = ad;
          _interstitialAdWasLoaded(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('OpeningAd failed to load: $error');
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

  Future<void> showloadOpeningAd() async {
    if (!interstitialAdWasLoaded) {
      await loadOpeningAd();
    } else if (!kDebugMode) {
      _interstitialAd.show();
      _interstitialAd.dispose();
      _interstitialAdWasLoaded(false);
    }
  }
}
