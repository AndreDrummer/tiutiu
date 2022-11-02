import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/Widgets/app_name_widget.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CurrentLocationController _currentLocationController = Get.find();

class LocalizationServiceAccessPermissionAccess extends StatelessWidget {
  const LocalizationServiceAccessPermissionAccess({
    this.localAccessDenied = false,
    this.gpsIsActive = false,
    super.key,
  });

  final bool localAccessDenied;
  final bool gpsIsActive;

  @override
  Widget build(BuildContext context) {
    debugPrint('>> local access denied? ${localAccessDenied ? 'Sim' : 'Não'}');

    return Scaffold(
      appBar: DefaultBasicAppBar(text: LocalPermissionStrings.appBarTitle),
      body: Column(
        children: [
          SizedBox(height: 16.0.h),
          _googleMapsPin(),
          Spacer(),
          _googleRoutesImage(),
          Spacer(),
          AppNameWidget(),
          SizedBox(height: 8.0.h),
          _explainAccessPermissionText(),
          Spacer(),
          _primaryButton(),
          Spacer(),
        ],
      ),
    );
  }

  CircleAvatar _googleMapsPin() {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image.asset(ImageAssets.googleMapsPin),
      ),
    );
  }

  Background _googleRoutesImage() => Background(image: ImageAssets.googlePlaces);

  Widget _explainAccessPermissionText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: AutoSizeTexts.autoSizeText16(
        gpsIsActive ? LocalPermissionStrings.needsAccess : LocalPermissionStrings.needsGPS,
        textAlign: TextAlign.center,
      ),
    );
  }

  ButtonWide _primaryButton() {
    return ButtonWide(
      onPressed: onPrimaryPressed,
      text: _getButtonText(),
    );
  }

  void onPrimaryPressed() {
    if (!gpsIsActive) {
      _currentLocationController.openDeviceSettings();
    } else {
      _currentLocationController.handleLocationPermission();
    }
  }

  String _getButtonText() {
    final currentPermission = _currentLocationController.permission;

    if (!gpsIsActive) {
      return LocalPermissionStrings.turnOnLocalization;
    } else {
      if (localAccessDenied) {
        if (currentPermission == LocationPermission.deniedForever) {
          return LocalPermissionStrings.openSettings;
        } else if (currentPermission == LocationPermission.denied) {
          return LocalPermissionStrings.grantAcess;
        }
      }
      return LocalPermissionStrings.grantAcess;
    }
  }
}
