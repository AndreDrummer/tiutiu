import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/system/model/app_properties.dart';
import 'package:tiutiu/core/system/service/app_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';

class AppController extends GetxController {
  AppController({required AppService systemService}) : _systemService = systemService;

  final AppService _systemService;

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
    _systemProperties(properties.copyWith(isLoading: true));
    await currentLocationController.updateGPSStatus();
    await currentLocationController.setUserLocation();
    await StatesAndCities.stateAndCities.getUFAndCities();
    await postsController.allPosts();
    await postsController.getCachedAssets();

    systemController.onAppPropertiesChange();
    _systemProperties(properties.copyWith(isLoading: false));
  }

  void onAppEndpointsChange() => _systemService.getAppEndpoints().listen(_endpoints);

  void onAppPropertiesChange() {
    _systemService.getAppProperties(properties).listen((realTimeproperties) {
      debugPrint('>> Current Properties $properties');

      _systemProperties(realTimeproperties);

      debugPrint('>> New Properties $properties');
    });
  }
}
