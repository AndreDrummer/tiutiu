import 'package:tiutiu/core/location/views/localization_service_access_permission_request.dart';
import 'package:tiutiu/core/extensions/service_location_status.dart';
import 'package:tiutiu/features/auth/views/auth_or_home.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/loading_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<AppBootstrap> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ServiceStatus>(
      stream: Geolocator.getServiceStatusStream(),
      builder: (context, snapshot) {
        debugPrint('TiuTiuApp: service status ${snapshot.data}');
        if (snapshot.data != null) {
          currentLocationController.updateGPSStatus();
        }

        return Obx(
          () {
            debugPrint('TiuTiuApp: GPS is active? ${currentLocationController.gpsStatus.isActive}');
            return currentLocationController.gpsStatus.isActive
                ? _RequestPermissionsOrHome()
                : LocalizationServiceAccessPermissionAccess(
                    gpsIsActive: currentLocationController.gpsStatus.isActive,
                  );
          },
        );
      },
    );
  }
}

class _RequestPermissionsOrHome extends StatelessWidget {
  const _RequestPermissionsOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentLocationController.checkPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        }

        return Obx(
          () {
            final accessDenied = isLocalAccessPermissionDenied(
              currentLocationController.permission,
            );

            if (accessDenied && !currentLocationController.canContinue) {
              return LocalizationServiceAccessPermissionAccess(
                gpsIsActive: currentLocationController.gpsStatus.isActive,
                localAccessDenied: accessDenied,
              );
            } else {
              return AuthOrHome();
            }
          },
        );
      },
    );
  }

  bool isLocalAccessPermissionDenied(
    LocationPermission currentLocationPermission,
  ) {
    return currentLocationPermission != LocationPermission.always &&
        currentLocationPermission != LocationPermission.whileInUse;
  }
}
