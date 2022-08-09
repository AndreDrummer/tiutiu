import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/features/location/views/current_local_acess_permission_view.dart';

final CurrentLocationController _currentLocationController = Get.find();

class AppBootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<AppBootstrap> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _buildBody(_currentLocationController.locationServiceStatus),
    );
  }

  Widget _buildBody(LocationServiceStatus locationStatus) {
    if (locationStatus == LocationServiceStatus.deactivated) {
      return StreamBuilder<ServiceStatus>(
        stream: Geolocator.getServiceStatusStream(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            _currentLocationController.updateLocationServiceStatus();
          }

          return CurrentLocalAccessPermissionView(
            locationServiceStatus: locationStatus,
          );
        },
      );
    }
    return AuthOrHome();
  }
}
