import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/system/service/system_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/system/model/endpoint.dart';
import 'package:get/get.dart';
import 'dart:async';

class SystemController extends GetxController {
  SystemController({required SystemService systemService}) : _systemService = systemService;

  final RxList<Endpoint> _endpoints = <Endpoint>[].obs;
  final RxString _systemStateTextFeedback = ''.obs;
  final RxBool _internetConnected = false.obs;
  final RxBool _bottomSheetIsOpen = false.obs;
  final RxBool _snackBarIsOpen = false.obs;
  final RxBool _isLoading = false.obs;

  final SystemService _systemService;

  String get systemStateTextFeedback => _systemStateTextFeedback.value;
  bool get internetConnected => _internetConnected.value;
  bool get bottomSheetIsOpen => _bottomSheetIsOpen.value;
  bool get snackBarIsOpen => _snackBarIsOpen.value;
  List<Endpoint> get endpoints => _endpoints;
  bool get isLoading => _isLoading.value;

  void set bottomSheetIsOpen(bool value) => _bottomSheetIsOpen(value);
  void set snackBarIsOpen(bool value) => _snackBarIsOpen(value);

  void setLoading(bool loadingValue, String systemStateTextFeedback) {
    _systemStateTextFeedback(systemStateTextFeedback);
    _isLoading(loadingValue);
  }

  void handleInternetConnectivityStatus() {
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        _internetConnected(true);
      } else {
        _internetConnected(false);
      }
    });
  }

  Future<void> loadApp() async {
    await currentLocationController.updateGPSStatus();
    await currentLocationController.setUserLocation();
    await StatesAndCities().getUFAndCities();
    await postsController.allPosts();
    await postsController.getCachedAssets();
  }

  void onAppEndpointsChange() => _systemService.getAppEndpoints().listen(_endpoints);
}
