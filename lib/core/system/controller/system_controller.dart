import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/system/service/system_service.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:tiutiu/core/system/model/system.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';

class SystemController extends GetxController {
  SystemController({required SystemService systemService}) : _systemService = systemService;

  final SystemService _systemService;

  final RxMap<String, dynamic> _adMobIDs = <String, dynamic>{}.obs;
  final Rx<System> _systemProperties = System().obs;
  final RxList<Endpoint> _endpoints = <Endpoint>[].obs;
  String initialFDLink = '';

  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  System get properties => _systemProperties.value;
  List<Endpoint> get endpoints => _endpoints;

  void set bottomSheetIsOpen(bool value) => _systemProperties(properties.copyWith(bottomSheetIsOpen: value));
  void set snackBarIsOpen(bool value) => _systemProperties(properties.copyWith(snackBarIsOpen: value));

  void setLoading(bool loadingValue, [String systemStateTextFeedback = '']) {
    _systemProperties(properties.copyWith(systemStateTextFeedback: systemStateTextFeedback));
    _systemProperties(properties.copyWith(isLoading: loadingValue));
  }

  void handleInternetConnectivityStatus() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        _systemProperties(properties.copyWith(internetConnected: true));
      } else {
        _systemProperties(properties.copyWith(internetConnected: false));
      }
    });
  }

  Future<void> loadApp() async {
    try {
      _systemProperties(properties.copyWith(isLoading: true));

      await getInitialEndpoints();
      await StatesAndCities.stateAndCities.getUFAndCities();
      await currentLocationController.updateGPSStatus();
      await currentLocationController.setUserLocation();
      await postsController.getAllPosts();
      await postsController.getCachedVideos();
      await _getAdMobIDs();

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _systemProperties(properties.copyWith(runningVersion: packageInfo.version));

      await handleFDLOpensApp();

      _systemProperties(properties.copyWith(isLoading: false));

      adminRemoteConfigController.onAdminRemoteConfigsChange();
      handleFDLOnForeground();
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'App Initialization Exception: $exception',
        exception: exception,
      );
    }
  }

  Future<void> getInitialEndpoints() async {
    final initialEndpoints = await _systemService.getEndpoints();
    _endpoints(initialEndpoints);
  }

  Future<void> _getAdMobIDs() async {
    final ids = await _systemService.getAdMobIds();

    _adMobIDs(ids);
  }

  void onAppEndpointsChange() => _systemService.appEndpoints().listen(_endpoints);

  void handleFDLOnForeground() {
    _firebaseDynamicLinks.onLink.listen((dynamicLinkData) {
      debugPrint('TiuTiuApp: FDL Foreground Data: $dynamicLinkData');
    }).onError((error) {
      debugPrint('TiuTiuApp: FDL Foreground Error: $error');
    });
  }

  Future handleFDLOpensApp() async {
    final PendingDynamicLinkData? initialLink = await _firebaseDynamicLinks.getInitialLink();
    debugPrint('TiuTiuApp: FDL Terminated InitialLink: $initialLink');
    final String? fdLink = '${initialLink?.link}';

    if (fdLink.isNotEmptyNeighterNull()) {
      initialFDLink = fdLink!;
      setPostDetail();
    }
  }

  void setPostDetail() {
    final allPosts = postsController.posts;
    final sharedAdId = initialFDLink.split('?').last;

    final postToOpenIn = allPosts.firstWhere((post) => post.uid == sharedAdId);
    postsController.post = postToOpenIn;
  }

  String getAdMobBlockID({required String blockName, required String type}) {
    final googleInterstitialtest = 'ca-app-pub-3940256099942544/4411468910';
    final googleBannerAdtest = 'ca-app-pub-3940256099942544/6300978111';
    final googleRewardedtest = 'ca-app-pub-3940256099942544/1712485313';
    final adMobID = _adMobIDs[blockName];

    String defaultID = '';

    debugPrint('TiuTiuApp: ADMOBBlock -> Name: $blockName ID: $adMobID');

    switch (type) {
      case AdMobType.banner:
        defaultID = googleBannerAdtest;
        break;
      case AdMobType.rewarded:
        defaultID = googleRewardedtest;
        break;
      case AdMobType.interstitial:
        defaultID = googleInterstitialtest;
        break;
    }

    return (adMobID == null || kDebugMode) ? defaultID : adMobID;
  }
}
