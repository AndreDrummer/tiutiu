import 'package:tiutiu/core/location/views/localization_service_access_permission_request.dart';
import 'package:tiutiu/core/system/views/loading_start_screen.dart';
import 'package:tiutiu/core/system/select_country_screen.dart';
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
    return FutureBuilder<PermissionStatus?>(
      future: currentLocationController.getLastLocationPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return LoadingStartScreen();

        final shouldRequestPermission = snapshot.data == null;

        return Obx(
          () {
            final accessDenied = isLocalAccessPermissionDenied(currentLocationController.permissionStatus);

            if (shouldRequestPermission && accessDenied && !currentLocationController.canContinue) {
              return LocalizationServiceAccessPermissionAccess(localAccessDenied: accessDenied);
            } else if (Localizations.localeOf(context).toLanguageTag() != 'pt') {
              return CountrySelecter();
            } else {
              return AuthOrHome();
            }
          },
        );
      },
    );
  }

  bool isLocalAccessPermissionDenied(PermissionStatus currentLocationPermission) =>
      currentLocationPermission != PermissionStatus.granted;
}
