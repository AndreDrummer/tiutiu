import 'package:get/get.dart';

// Nexus 05 --> 616
// Pixel 30 --> 683
// Redmi 08 --> 834
// iPhone 14 -> 932

class Dimensions {
  static double getDimensBasedOnDeviceHeight({
    double minDeviceHeight = 616,
    double medDeviceHeight = 834,
    required double smaller,
    required double bigger,
    required double medium,
  }) {
    if (Get.height <= minDeviceHeight) return smaller;
    if (Get.height > minDeviceHeight && Get.height <= medDeviceHeight) return medium;
    return bigger;
  }
}
