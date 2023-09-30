import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CrashlyticsController extends GetxController with TiuTiuPopUp {
  Future<void> init() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    final userAllowsTrackFailures = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.enableCrashlytics);

    if (userAllowsTrackFailures == null) {
      if (kDebugMode) debugPrint('TiuTiuApp: User TrackFailures Decision is NULL');
      _promptRequestToTrack();
    } else {
      final realUserTrackFailuresDecision = FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled;

      if (kDebugMode) debugPrint('TiuTiuApp: Current User TrackFailures Decision is $realUserTrackFailuresDecision');
      if (kDebugMode) debugPrint('TiuTiuApp: Cashed User TrackFailures Decision is $userAllowsTrackFailures');
      _setCrashlyticsCollectionEnabled(value: userAllowsTrackFailures && !kDebugMode);
    }
  }

  Future<void> reportAnError({
    required String message,
    StackTrace? stackTrace,
    required exception,
  }) async {
    if (kDebugMode)
      debugPrint('TiuTiuApp: Reporting crash:\nMessage\n$message\nException\n$exception\nStackTrace\n$stackTrace\n');

    await FirebaseCrashlytics.instance.setUserIdentifier('${tiutiuUserController.tiutiuUser.uid}');

    await FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      reason: message,
    );
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
      message: AppLocalizations.of(Get.context!)!.crashlyticsInfo,
      backGroundColor: AppColors.info,
      confirmText: AppLocalizations.of(Get.context!)!.yes,
      title: AppLocalizations.of(Get.context!)!.warning,
      barrierDismissible: false,
      denyText: AppLocalizations.of(Get.context!)!.no,
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
