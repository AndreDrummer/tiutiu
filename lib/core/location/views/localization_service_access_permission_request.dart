import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/app_name_widget.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/widgets/background.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class LocalizationServiceAccessPermissionAccess extends StatelessWidget {
  const LocalizationServiceAccessPermissionAccess({
    this.localAccessDenied = false,
    this.showSpyButton = true,
    this.gpsIsActive = false,
    super.key,
  });

  final bool localAccessDenied;
  final bool showSpyButton;
  final bool gpsIsActive;

  @override
  Widget build(BuildContext context) {
    debugPrint('TiuTiuApp: local access denied? ${localAccessDenied ? 'Sim' : 'Não'}');

    return Scaffold(
        appBar: DefaultBasicAppBar(text: LocalPermissionStrings.appBarTitle),
        body: Center(
          child: Column(
            children: [
              _petPawPin(),
              SizedBox(height: 32.0.h),
              _googleRoutesImage(),
              SizedBox(height: Get.width / 8),
              AppNameWidget(),
              SizedBox(height: 8.0.h),
              _explainAccessPermissionText(),
              SizedBox(height: 8.0.h),
              _warningAboutConfigsSeetings(),
              Spacer(),
              _primaryButton(),
              Spacer(),
            ],
          ),
        ));
  }

  Widget _petPawPin() {
    return LottieAnimation(animationPath: AnimationsAssets.petLocationPin, size: 120.0.h);
  }

  Background _googleRoutesImage() => Background(image: ImageAssets.googlePlaces);

  Widget _warningAboutConfigsSeetings() {
    return Visibility(
      visible: currentLocationController.permission == LocationPermission.deniedForever && Platform.isAndroid,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: AutoSizeTexts.autoSizeText14(
          LocalPermissionStrings.permissionDeniedForeverWarning,
          textAlign: TextAlign.center,
          color: AppColors.danger,
        ),
      ),
    );
  }

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
    if (!gpsIsActive || currentLocationController.permission == LocationPermission.deniedForever) {
      currentLocationController.openDeviceSettings();
    } else {
      currentLocationController.handleLocationPermission();
    }
  }

  String _getButtonText() {
    if (!gpsIsActive) {
      return LocalPermissionStrings.turnOnLocalization;
    } else {
      if (currentLocationController.permission == LocationPermission.deniedForever) {
        return LocalPermissionStrings.openSettings;
      } else if (currentLocationController.permission == LocationPermission.denied) {
        return LocalPermissionStrings.grantAcess;
      }

      return LocalPermissionStrings.grantAcess;
    }
  }
}
