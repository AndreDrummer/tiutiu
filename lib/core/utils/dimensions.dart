import 'package:get/get.dart';

// Height
// iPhone 14 -----> 932 (Big)
// iPhone 07 -----> 667 (Small)
// Redmi 08 Pro --> 834 (Medium)
// Pixel 06 Pro --> 867 (Medium)
// Nexus 05 ------> 616 (xSmall)

// Aspect Ratio
// iPhone 14 ------> 0.4613
// iPhone 07 ------> 0.5622
// Redmi Note 08 --> 0.4703
// Pixel 06 Pro----> 0.4743
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

  static bool isSmallDevice() => Get.height > _xSmallDeviceMaxSize && Get.height <= _smallDeviceMaxSize;
  static bool isMediumDevice() => Get.height > _smallDeviceMaxSize && Get.height <= _mediumDeviceMaxSize;
  static bool isXSmallDevice() => Get.height <= _xSmallDeviceMaxSize;
  static bool isBigDevice() => Get.height > _bigDeviceMinimumSize;

  static double _bigDeviceMinimumSize = 900;
  static double _xSmallDeviceMaxSize = 650;
  static double _mediumDeviceMaxSize = 900;
  static double _smallDeviceMaxSize = 750;
}
