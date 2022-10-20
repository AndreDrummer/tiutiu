import 'package:tiutiu/features/location/controller/current_location_controller.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/Widgets/app_name_widget.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CurrentLocationController _currentLocationController = Get.find();

class TurnOnLocalizationService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  Background _googleRoutesImage() =>
      Background(image: ImageAssets.googlePlaces);

  AutoSizeText _explainAccessPermissionText() {
    return AutoSizeText(
      LocalPermissionStrings.needsAccess,
      style: TextStyles.fontSize16(),
      textAlign: TextAlign.center,
    );
  }

  ButtonWide _primaryButton() {
    return ButtonWide(
      onPressed: _currentLocationController.openDeviceSettings,
      text: LocalPermissionStrings.turnOnLocalization,
    );
  }
}
