import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/system/model/app_properties.dart';
import 'package:tiutiu/core/system/service/app_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';

class AppController extends GetxController {
  AppController({required AppService systemService}) : _systemService = systemService;

  final AppService _systemService;

  final RxMap<String, dynamic> _adMobIDs = <String, dynamic>{}.obs;
  final Rx<AppProperties> _systemProperties = AppProperties().obs;
  final RxList<Endpoint> _endpoints = <Endpoint>[].obs;

  AppProperties get properties => _systemProperties.value;
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

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _systemProperties(properties.copyWith(runningVersion: packageInfo.version));

      _systemProperties(properties.copyWith(isLoading: false));

      await _getAdMobIDs();
      appController.onAppPropertiesChange();
    } on Exception catch (exception) {
      debugPrint('TiuTiuApp: App Initialization Exception $exception');
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

  void onAppPropertiesChange() {
    _systemService.getAppProperties(properties).listen((realTimeproperties) {
      debugPrint('TiuTiuApp: Current Properties $properties');

      _systemProperties(realTimeproperties);

      debugPrint('TiuTiuApp: New Properties $properties');
    });
  }

  String getAdMobBlockID({required String blockName}) {
    final googleBannerAdtest = 'ca-app-pub-3940256099942544/6300978111';
    final adMobID = _adMobIDs[blockName];

    return (adMobID == null || kDebugMode) ? googleBannerAdtest : adMobID;
  }
}
