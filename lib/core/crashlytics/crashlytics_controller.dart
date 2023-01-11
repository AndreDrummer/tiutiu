import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CrashlyticsController extends GetxController with TiuTiuPopUp {
  Future<void> init() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    final userAllowsTrackFailures = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.enableCrashlytics);

    if (userAllowsTrackFailures == null) {
      debugPrint('TiuTiuApp: User TrackFailures Decision is NULL');
      _promptRequestToTrack();
    } else {
      final realUserTrackFailuresDecision = FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;

      debugPrint('TiuTiuApp: Current User TrackFailures Decision is $realUserTrackFailuresDecision');
      debugPrint('TiuTiuApp: Cashed User TrackFailures Decision is $userAllowsTrackFailures');
      _setCrashlyticsCollectionEnabled(value: userAllowsTrackFailures);
    }
  }

  Future<void> reportAnError({required exception, StackTrace? stackTrace, required String message}) async {
    debugPrint('TiuTiuApp: Reporting to firebase:\n\n$message\n\n$exception\n\n$stackTrace\n');
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace, reason: message);
  }

  Future<void> _setCrashlyticsCollectionEnabled({bool value = false}) async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(value);

    await LocalStorage.setValueUnderLocalStorageKey(
      key: LocalStorageKey.enableCrashlytics,
      value: value,
    );
  }

  Future<void> _promptRequestToTrack() async {
    showPopUp(
      message: AppStrings.crashlyticsInfo,
      backGroundColor: AppColors.info,
      confirmText: AppStrings.yes,
      title: AppStrings.warning,
      barrierDismissible: false,
      denyText: AppStrings.no,
      mainAction: () {
        Get.back();
        _setCrashlyticsCollectionEnabled(value: false);
      },
      secondaryAction: () {
        Get.back();
        _setCrashlyticsCollectionEnabled(value: true);
      },
    );
  }
}
