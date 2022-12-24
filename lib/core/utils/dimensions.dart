import 'package:get/get.dart';

// Nexus 05 --> 616
// Pixel 30 --> 683
// Redmi 08 --> 834
// iPhone 14 -> 932

class Dimensions {
  static double getDimensBasedOnDeviceHeight({
    required double smaller,
    required double bigger,
    required double medium,
  }) {
    if (isMediumDevice()) return medium;
    if (isSmallDevice()) return smaller;
    return bigger;
  }

  static bool isMediumDevice() => Get.height > 616 && Get.height <= 835;
  static bool isSmallDevice() => Get.height <= 616;
  static bool isBigDevice() => Get.height > 835;
}
