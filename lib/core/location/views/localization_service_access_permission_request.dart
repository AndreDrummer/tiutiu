import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/lottie_animation.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/app_name_widget.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/widgets/background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationServiceAccessPermissionAccess extends StatefulWidget {
  const LocalizationServiceAccessPermissionAccess({
    this.localAccessDenied = false,
    this.isInPostScreen = false,
    super.key,
  });

  final bool localAccessDenied;
  final bool isInPostScreen;

  @override
  State<LocalizationServiceAccessPermissionAccess> createState() => _LocalizationServiceAccessPermissionAccessState();
}

class _LocalizationServiceAccessPermissionAccessState extends State<LocalizationServiceAccessPermissionAccess>
    with TiuTiuPopUp {
  final ValueNotifier<PermissionStatus> locationAccessStatus =
      ValueNotifier<PermissionStatus>(PermissionStatus.limited);
  bool get isInPostScreen => widget.isInPostScreen;

  Future<PermissionStatus> getPermissionStatus() async => Permission.location.status;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) debugPrint('TiuTiuApp: local access denied? ${widget.localAccessDenied ? 'Sim' : 'Não'}');

    return Scaffold(
      appBar: DefaultBasicAppBar(text: AppLocalizations.of(context)!.appBarTitle),
      body: FutureBuilder<PermissionStatus>(
        future: getPermissionStatus(),
        builder: (context, snapshot) {
          return AsyncHandler<PermissionStatus>(
            snapshot: snapshot,
            buildWidget: (status) {
              locationAccessStatus.value = status;

              return Center(
                child: Column(
                  children: [
                    _petPawPin(),
                    SizedBox(height: 32.0.h),
                    _googleRoutesImage(),
                    SizedBox(height: Get.width / 8),
                    AppNameWidget(),
                    SizedBox(height: 16.0.h),
                    _explainAccessPermissionText(),
                    Spacer(),
                    _primaryButton(),
                    Spacer(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _petPawPin() => LottieAnimation(animationPath: AnimationsAssets.petLocationPin, size: 120.0.h);

  Background _googleRoutesImage() => Background(image: ImageAssets.googlePlaces);

  Widget _explainAccessPermissionText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: AutoSizeTexts.autoSizeText16(
        isInPostScreen ? AppLocalizations.of(context)!.needsAccessToPost : AppLocalizations.of(context)!.needsAccess,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _primaryButton() {
    return ValueListenableBuilder(
      valueListenable: locationAccessStatus,
      builder: (context, value, child) {
        String? buttonText;

        if (locationAccessStatus.value == PermissionStatus.permanentlyDenied) {
          buttonText = AppLocalizations.of(context)!.contines;
        } else if (locationAccessStatus.value == PermissionStatus.denied) {
          buttonText = AppLocalizations.of(context)!.ok;
        }

        return ButtonWide(onPressed: () async => onPrimaryPressed(), text: buttonText);
      },
    );
  }

  Future<void> onPrimaryPressed() async {
    if (locationAccessStatus.value == PermissionStatus.permanentlyDenied) {
      await Permission.location.request().then((permission) async {
        locationAccessStatus.value = permission;
        await currentLocationController.setPermission(permission);
        if (currentLocationController.permissionStatus == PermissionStatus.permanentlyDenied) await showWarningPopup();
      });
    } else {
      locationAccessStatus.value = await Permission.location.request();
      await currentLocationController.setPermission(locationAccessStatus.value);

      if (locationAccessStatus.value == PermissionStatus.permanentlyDenied) {
        await showWarningPopup();
      }
    }
  }

  Future<void> showWarningPopup() async {
    final message = isInPostScreen
        ? AppLocalizations.of(Get.context!)!.appNeedToKnowWhereYouAre
        : AppLocalizations.of(Get.context!)!.appNeedToKnowWhereYouAreToShowNearestPets;

    return await showPopUp(
      message: message,
      confirmText: 'Abrir configurações',
      title: AppLocalizations.of(context)!.localization,
      denyText: isInPostScreen ? 'Não quero postar agora' : 'Somente ver os PETs',
      barrierDismissible: false,
      secondaryAction: () {
        Get.back();
        currentLocationController.openDeviceSettings();
      },
      mainAction: () {
        currentLocationController.canContinue = true;
        Get.back();
      },
      backGroundColor: AppColors.info,
    );
  }
}
