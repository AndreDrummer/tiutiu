import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/core/system/service/system_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:tiutiu/core/system/model/system.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

class SystemController extends GetxController {
  SystemController({required SystemService systemService}) : _systemService = systemService;

  final SystemService _systemService;

  final RxMap<String, dynamic> _adMobIDs = <String, dynamic>{}.obs;
  final RxList<Endpoint> _endpoints = <Endpoint>[].obs;
  final Rx<System> _systemProperties = System().obs;
  final RxBool _isToCloseApp = false.obs;
  String initialFDLink = '';

  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  System get properties => _systemProperties.value;
  bool get isToCloseApp => _isToCloseApp.value;

  List<Endpoint> get endpoints => _endpoints;

  void set snackBarIsOpen(bool value) => _systemProperties(properties.copyWith(snackBarIsOpen: value));
  void set isToCloseApp(bool value) => _isToCloseApp(value);

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
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _systemProperties(properties.copyWith(runningVersion: packageInfo.version));

      await getInitialEndpoints();

      await StatesAndCities.stateAndCities.getUFAndCities();
      await currentLocationController.setUserLocation();
      await sponsoredController.sponsoredAds();
      await postsController.getAllPosts();
      await _getAdMobIDs();

      await handleFDLOpensApp();
      await checkUserTermsAccepted();
      await setUserChoiceCountry();
      await setUserChoiceRadiusDistanceToShowPets();

      adMobController.loadWhatsAppRewardedAd();
      adMobController.loadChatRewardedAd();

      adminRemoteConfigController.onAdminRemoteConfigsChange();
      handleFDLOnForeground();

      _systemProperties(
        properties.copyWith(
          accessLocationDenied: await updateAccessToLocationWasDenied(),
        ),
      );

      _systemProperties(properties.copyWith(isLoading: false));
    } on Exception catch (exception) {
      crashlyticsController.reportAnError(
        message: 'App Initialization Exception: $exception',
        exception: exception,
      );
    }
  }

  Future<void> setUserChoiceCountry() async {
    final country = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.userChoiceCountry);
    _systemProperties(properties.copyWith(userChoiceCountry: country));
  }

  Future<void> setUserChoiceRadiusDistanceToShowPets() async {
    final distance =
        await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.userChoiceRadiusDistanceToShowPets);
    _systemProperties(properties.copyWith(userChoiceRadiusDistanceToShowPets: distance ?? 10));
  }

  Future<void> checkUserTermsAccepted() async {
    final termsAccepted = await LocalStorage.getUnderBooleanKey(
      key: LocalStorageKey.termsAndConditions,
      standardValue: false,
    );

    _systemProperties(properties.copyWith(hasAcceptedTerms: termsAccepted));
  }

  Future<bool> updateAccessToLocationWasDenied() async {
    final permissionStatus = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.userLocationDecision);
    if (kDebugMode) debugPrint('TiuTiuApp: LocationAccess: $permissionStatus');

    return permissionStatus == PermissionStatus.denied.name;
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
      if (kDebugMode) debugPrint('TiuTiuApp: FDL Foreground Data: $dynamicLinkData');
    }).onError((error) {
      if (kDebugMode) debugPrint('TiuTiuApp: FDL Foreground Error: $error');
    });
  }

  Future handleFDLOpensApp() async {
    final PendingDynamicLinkData? initialLink = await _firebaseDynamicLinks.getInitialLink();
    if (kDebugMode) debugPrint('TiuTiuApp: FDL Terminated InitialLink: $initialLink');
    final String? fdLink = '${initialLink?.link}';

    if (fdLink.isNotEmptyNeighterNull()) {
      initialFDLink = fdLink!;
      setPostDetail();
    }
  }

  Future<BaseDeviceInfo> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = Platform.isIOS ? await deviceInfo.iosInfo : await deviceInfo.androidInfo;

    if (kDebugMode) debugPrint('TiuTiuApp: Device Info: $info');

    return info;
  }

  Future<PackageInfo> getPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (kDebugMode) debugPrint('TiuTiuApp: Package Info: $info');

    return info;
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

    if (kDebugMode) debugPrint('TiuTiuApp: ADMOBBlock -> Name: $blockName ID: $adMobID');

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
