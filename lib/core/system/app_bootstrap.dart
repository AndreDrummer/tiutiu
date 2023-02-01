import 'package:tiutiu/core/location/views/localization_service_access_permission_request.dart';
import 'package:tiutiu/features/auth/views/auth_or_home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<AppBootstrap> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final accessDenied = isLocalAccessPermissionDenied(currentLocationController.permission);

        if (accessDenied && !currentLocationController.canContinue) {
          return LocalizationServiceAccessPermissionAccess(localAccessDenied: accessDenied);
        } else {
          return AuthOrHome();
        }
      },
    );
  }

  bool isLocalAccessPermissionDenied(PermissionStatus currentLocationPermission) =>
      currentLocationPermission != PermissionStatus.granted;
}
