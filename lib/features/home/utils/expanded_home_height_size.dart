import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:get/get.dart';

double expandedHomeHeightDefault({required bool showingSponsoredAds}) {
  return Dimensions.getDimensBasedOnDeviceHeight(
    smaller: showingSponsoredAds ? Get.height / 2.60 : Get.height / 3.70,
    medium: showingSponsoredAds ? Get.height / 3.10 : Get.height / 4.4,
    bigger: showingSponsoredAds ? Get.height / 3.10 : Get.height / 4.5,
  );
}

double expandedHomeHeightWithAdminInfoAndInternetConnection({required bool showingSponsoredAds}) {
  return Dimensions.getDimensBasedOnDeviceHeight(
    xSmaller: showingSponsoredAds ? Get.height / 2.25 : Get.height / 3.1,
    smaller: showingSponsoredAds ? Get.height / 2.35 : Get.height / 3.2,
    medium: showingSponsoredAds ? Get.height / 2.70 : Get.height / 3.70,
    bigger: showingSponsoredAds ? Get.height / 2.80 : Get.height / 3.8,
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
