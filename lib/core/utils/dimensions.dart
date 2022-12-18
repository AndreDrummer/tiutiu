import 'package:get/get.dart';

// Nexus 5 -> 616
// Pixel30 -> 683
// Redmi 8 -> 834

class Dimensions {
  static double getDimensBasedOnDeviceHeight({
    required double smaller,
    required double bigger,
    double minDeviceHeight = 617,
  }) {
    if (Get.height <= minDeviceHeight) return smaller;
    return bigger;
  }
}
