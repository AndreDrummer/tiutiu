import 'package:get/get.dart';

class Dimensions {
  static double getDimensBasedOnDeviceHeight({
    required double greaterDeviceHeightDouble,
    required double minDeviceHeightDouble,
    double minDeviceHeight = 850,
  }) {
    if (Get.height <= minDeviceHeight) return minDeviceHeightDouble;
    return greaterDeviceHeightDouble;
  }
}
