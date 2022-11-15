import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class SystemController extends GetxController {
  RxBool _internetConnected = false.obs;
  RxBool _bottomSheetIsOpen = false.obs;
  RxBool _snackBarIsOpen = false.obs;

  bool get internetConnected => _internetConnected.value;
  bool get bottomSheetIsOpen => _bottomSheetIsOpen.value;
  bool get snackBarIsOpen => _snackBarIsOpen.value;

  void set bottomSheetIsOpen(bool value) => _bottomSheetIsOpen(value);
  void set snackBarIsOpen(bool value) => _snackBarIsOpen(value);

  void handleInternetConnectivityStatus(
    ConnectivityResult? connectivityResult,
  ) {
    if (connectivityResult == null) {
      _internetConnected(false);
    } else if (connectivityResult == ConnectivityResult.none) {
      _internetConnected(false);
    } else {
      _internetConnected(true);
    }
  }
}
