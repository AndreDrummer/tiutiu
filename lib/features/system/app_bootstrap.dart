import 'package:tiutiu/features/location/views/request_current_local_acess_permission_view.dart';
import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/features/location/extensions/service_location_status.dart';
import 'package:tiutiu/features/location/views/turn_on_localization_service.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CurrentLocationController _currentLocationController = Get.find();

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
          _currentLocationController.updateGPSStatus();
        }

        return Obx(
          () => _currentLocationController.gpsStatus.isActive
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
      future: _currentLocationController.checkPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadDarkScreen(),
          );
        }
        return Obx(
          () {
            final accessDenied = isLocalAccessPermissionDenied(
              _currentLocationController.permission,
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
