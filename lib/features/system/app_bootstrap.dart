import 'package:tiutiu/features/location/views/request_current_local_acess_permission_view.dart';
import 'package:tiutiu/features/location/extensions/service_location_status.dart';
import 'package:tiutiu/features/location/views/turn_on_localization_service.dart';
import 'package:tiutiu/features/auth/views/auth_or_home.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/loading_page.dart';
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
        if (snapshot.data != null) {
          currentLocationController.updateGPSStatus();
        }

        return Obx(
          () => currentLocationController.gpsStatus.isActive
              ? _RequestPermissionsOrHome()
              : TurnOnLocalizationService(),
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

            if (accessDenied) {
              return RequestCurrentLocalAccessPermissionView();
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
