import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SystemController extends GetxController {
  RxBool _internetConnected = false.obs;

  bool get internetConnected => _internetConnected.value;

  void handleInternetConnectivityStatus(
      ConnectivityResult? connectivityResult) {
    debugPrint('Result $connectivityResult');
    if (connectivityResult == null) {
      _internetConnected(false);
    } else if (connectivityResult == ConnectivityResult.none) {
      _internetConnected(false);
    } else {
      _internetConnected(true);
    }
  }
}
