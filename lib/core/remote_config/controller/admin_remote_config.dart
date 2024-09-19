import 'package:tiutiu/core/remote_config/services/admin_remote_config_services.dart';
import 'package:tiutiu/core/remote_config/model/admin_remote_config.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/other_functions.dart';
import 'package:get/get.dart';

class AdminRemoteConfigController extends GetxController {
  AdminRemoteConfigController({
    required AdminRemoteConfigServices adminRemoteConfigServices,
  }) : _adminRemoteConfigServices = adminRemoteConfigServices;

  final AdminRemoteConfigServices _adminRemoteConfigServices;

  final Rx<AdminRemoteConfig> _adminRemoteConfig = AdminRemoteConfig().obs;

  AdminRemoteConfig get configs => _adminRemoteConfig.value;

  void onAdminRemoteConfigsChange() {
    _adminRemoteConfigServices
        .getAdminRemoteConfig(configs)
        .listen((realTimeConfigs) {
      // if (kDebugMode) debugPrint('TiuTiuApp: Current Remote Configs $configs');

      _adminRemoteConfig(realTimeConfigs);

      final appIsClosed = realTimeConfigs.appIsClosed;
      final runningVersion = systemController.properties.runningVersion;
      final closeInVersionsSmallerThan =
          realTimeConfigs.closeInVersionsSmallerThan;

      systemController.isToCloseApp = OtherFunctions.isSmallerThan(
              runningVersion, closeInVersionsSmallerThan) &&
          appIsClosed;

      // if (kDebugMode) debugPrint('TiuTiuApp: New Remote Configs $configs');
    });
  }
}
