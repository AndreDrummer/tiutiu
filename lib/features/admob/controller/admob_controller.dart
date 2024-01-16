import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AdMobController {
  late InterstitialAd _interstitialAd;

  bool _interstitialAdWasLoaded = false;
  bool _interstitialAdWasShown = false;

  late RewardedAd _rewardedAd;

  bool _rewardedAdWasLoaded = false;

  int minutesFreeOfRewardedAd(ContactType contactType) {
    if (contactType == ContactType.whatsapp) return 7;
    return 15;
  }

  Future<void> loadWhatsAppRewardedAd() async => await _loadRewardedAd(AdMobBlockName.whatsappQuoteAdBlockId);

  Future<void> loadChatRewardedAd() async => await _loadRewardedAd(AdMobBlockName.chatQuoteAdBlockId);

  Future<void> _loadRewardedAd(String adBlockName) async {
    try {
      await RewardedAd.load(
        adUnitId: systemController.getAdMobBlockID(blockName: adBlockName, type: AdMobType.rewarded),
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('RewardedAd $ad loaded.');
            this._rewardedAd = ad;
            _rewardedAdWasLoaded = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ),
      );
    } catch (exception) {
      crashlyticsController.reportAnError(
        message: 'An error ocurred when trying load Rewarded Ad: $exception.',
        exception: exception,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> showRewardedAd(ContactType contactType, bool allowGoogleAds) async {
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

    if (allowGoogleAds) {
      _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
          ad.dispose();
          if (kDebugMode) debugPrint('TiuTiuApp: Usuário assistiu certinho ${ad.adUnitId} ${rewardItem.amount}');

          await LocalStorage.setValueUnderLocalStorageKey(
            key: contactType == ContactType.whatsapp
                ? LocalStorageKey.lastTimeWatchedWhatsappRewarded
                : LocalStorageKey.lastTimeWatchedChatRewarded,
            value: DateTime.now().toIso8601String(),
          );
        },
      ).then((_) => _rewardedAdWasLoaded = false);
    }
  }

  Future<void> loadOpeningAd() async {
    final String androidIntertitialAdId = 'ca-app-pub-2837828701670824/9465656437';
    final String iOSIntertitialAdId = 'ca-app-pub-2837828701670824/3404285743';
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
          _interstitialAdWasLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('OpeningAd failed to load: $error');
        },
      ),
    );

    if (_interstitialAdWasLoaded) {
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

  Future<void> showOpeningAd() async {
    final allowAdOnOpening = adminRemoteConfigController.configs.allowAdOnOpening;
    final allowGoogleAds = adminRemoteConfigController.configs.allowGoogleAds;

    if (!_interstitialAdWasLoaded) {
      debugPrint('Intertitial Ad NOT loaded.');
      await loadOpeningAd();
    } else if (allowAdOnOpening && !_interstitialAdWasShown && allowGoogleAds) {
      debugPrint('Intertitial Ad loaded. $_interstitialAdWasShown');
      _interstitialAd.show();
      _interstitialAd.dispose();
      _interstitialAdWasShown = true;
      debugPrint('Intertitial Ad Showed $_interstitialAdWasShown.');
    }
  }
}
