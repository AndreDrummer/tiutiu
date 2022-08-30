import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/features/location/controller/current_location_controller.dart';

final CurrentLocationController _currentLocationController = Get.find();

class TurnOnLocalizationService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          LocalPermissionStrings.appBarTitle,
          style: TextStyles.fontSize18(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Background(image: ImageAssets.googlePlaces),
              Positioned(
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.asset(ImageAssets.googleMapsPin),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        AppStrings.name,
                        style: GoogleFonts.miltonianTattoo(
                          textStyle: TextStyle(
                            letterSpacing: 12,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        LocalPermissionStrings.needsAccess,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.2,
                      ),
                      ButtonWide(
                        action: _currentLocationController.openDeviceSettings,
                        text: LocalPermissionStrings.turnOnLocalization,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
