import 'package:get/get.dart';

// Pixel 30 -> 683
// Redmi 834

class Dimensions {
  static double getDimensBasedOnDeviceHeight({
    required double greaterDeviceHeightDouble,
    required double minDeviceHeightDouble,
    double minDeviceHeight = 684,
  }) {
    if (Get.height <= minDeviceHeight) return minDeviceHeightDouble;
    return greaterDeviceHeightDouble;
  }
}
