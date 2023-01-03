import 'package:get/get.dart';

// Height
// Nexus 05 --> 616
// Pixel 06 --> 683
// Redmi 08 --> 834
// iPhone 14 -> 932
// iPhone 07 -> 667

// Aspect Ratio
// iPhone 07 ------> 0.5622
// iPhone 14 ------> 0.4613
// Redmi Note 08 --> 0.4703
// Pixel 06 -------> 0.4743
// Nexus 05 -------> 0.5844

class Dimensions {
  static double getDimensBasedOnDeviceHeight({
    required double smaller,
    required double bigger,
    required double medium,
    double? xSmaller,
  }) {
    if (isMediumDevice()) return medium;
    if (isSmallDevice()) return smaller;
    if (isBigDevice()) return bigger;

    return (isXSmallDevice() && xSmaller != null) ? xSmaller : smaller;
  }

  static bool isMediumDevice() => Get.height > 690 && Get.height <= 835;
  static bool isSmallDevice() => Get.height > 650 && Get.height <= 690;
  static bool isXSmallDevice() => Get.height <= 650;
  static bool isBigDevice() => Get.height > 835;
}
