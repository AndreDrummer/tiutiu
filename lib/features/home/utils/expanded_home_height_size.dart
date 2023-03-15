import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:get/get.dart';

double expandedHomeHeightDefault({required bool showingSponsoredAds}) {
  return Dimensions.getDimensBasedOnDeviceHeight(
    smaller: showingSponsoredAds ? Get.height / 5.0 : Get.width / 6.0,
    medium: showingSponsoredAds ? Get.height / 6.0 : Get.width / 6.0,
    bigger: showingSponsoredAds ? Get.height / 6.0 : Get.width / 6.0,
    tablet: showingSponsoredAds ? Get.height / 5.0 : Get.width / 7.5,
  );
}

double expandedHomeHeightWithAdminInfoAndInternetConnection({required bool showingSponsoredAds}) {
  return Dimensions.getDimensBasedOnDeviceHeight(
    xBigger: showingSponsoredAds ? Get.height / 2.40 : Get.height / 3.40,
    smaller: showingSponsoredAds ? Get.height / 3.70 : Get.width / 3.80,
    medium: showingSponsoredAds ? Get.height / 4.70 : Get.width / 3.80,
    bigger: showingSponsoredAds ? Get.height / 4.50 : Get.width / 4.0,
    tablet: showingSponsoredAds ? Get.height / 4.40 : Get.width / 5.0,
  );
}

double expandedHomeHeightWithoutInternetConnection({required bool showingSponsoredAds}) {
  return Dimensions.getDimensBasedOnDeviceHeight(
    xSmaller: Get.height / 3.1,
    smaller: Get.height / 3.2,
    bigger: Get.height / 3.8,
    medium: Get.height / 3.7,
  );
}
