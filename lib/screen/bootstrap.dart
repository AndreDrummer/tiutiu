import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/controllers/location_controller.dart';
import 'package:tiutiu/features/refine_search/controller/refine_search_controller.dart';
import 'package:tiutiu/screen/auth_or_home.dart';
import 'package:tiutiu/screen/local_permission.dart';

final RefineSearchController _refineSearchController = Get.find();
final LocationController _locationController = Get.find();

class Bootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    if (!_locationController.locationServiceEnabled) {
      return LocalPermissionScreen(
        permissionCallBack: _locationController.openLocalSettings,
        serviceEnabled: false,
      );
    } else if (_locationController.permission ==
        LocationPermission.deniedForever) {
      return LocalPermissionScreen(
        permissionCallBack: _locationController.openSeetings,
        deniedForever: true,
      );
    } else if (_locationController.permission == LocationPermission.denied) {
      return LocalPermissionScreen(
        permissionCallBack: _locationController.permissionRequest,
      );
    }
    _locationController.setLocation();
    return AuthOrHome();
  }
}
