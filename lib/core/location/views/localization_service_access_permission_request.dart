import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
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
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationServiceAccessPermissionAccess extends StatefulWidget {
  const LocalizationServiceAccessPermissionAccess({
    this.requestPermissionOnInit = false,
    this.localAccessDenied = false,
    this.isInPostScreen = false,
    super.key,
  });

  final bool requestPermissionOnInit;
  final bool localAccessDenied;
  final bool isInPostScreen;

  @override
  State<LocalizationServiceAccessPermissionAccess> createState() => _LocalizationServiceAccessPermissionAccessState();
}

class _LocalizationServiceAccessPermissionAccessState extends State<LocalizationServiceAccessPermissionAccess>
    with TiuTiuPopUp {
  final ValueNotifier<PermissionStatus> locationAccessStatus =
      ValueNotifier<PermissionStatus>(PermissionStatus.limited);
  bool get requestPermissionOnInit => widget.requestPermissionOnInit;
  bool get isInPostScreen => widget.isInPostScreen;

  Future<PermissionStatus> getPermissionStatus() async {
    if (requestPermissionOnInit) {
      return Permission.location.request();
    }
    return Permission.location.status;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) debugPrint('TiuTiuApp: local access denied? ${widget.localAccessDenied ? 'Sim' : 'Não'}');

    return Scaffold(
      appBar: DefaultBasicAppBar(text: LocalPermissionStrings.appBarTitle),
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
                    SizedBox(height: 8.0.h),
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
        LocalPermissionStrings.needsAccess,
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
          buttonText = AppStrings.contines;
        } else if (locationAccessStatus.value == PermissionStatus.denied) {
          buttonText = LocalPermissionStrings.grantAcess;
        }

        return ButtonWide(onPressed: () async => onPrimaryPressed(), text: buttonText);
      },
    );
  }

  Future<void> onPrimaryPressed() async {
    print(locationAccessStatus.value);
    if (locationAccessStatus.value == PermissionStatus.permanentlyDenied) {
      await showWarningPopup();
    } else {
      locationAccessStatus.value = await Permission.location.request();
      if (locationAccessStatus.value == PermissionStatus.permanentlyDenied) {
        await showWarningPopup();
      }
    }
  }

  Future<void> showWarningPopup() async {
    return await showPopUp(
      message:
          'O Tiutiu funciona melhor com o acesso a localização. Você até pode entrar e ver a lista de PETS, mas se for fazer uma publicação, vai precisar autorizar o acesso a sua localização!\n\nO que você quer fazer?',
      confirmText: 'Abrir configurações e conceder o acesso',
      title: LocalPermissionStrings.localization,
      denyText: isInPostScreen ? 'Não quero postar agora' : 'Continuar sem dar acesso',
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
