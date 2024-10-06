import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/core/widgets/popup_message.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:app_settings/app_settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

enum PickerAssetType {
  photo,
  video,
}

mixin Pickers {
  Future<void> pickAnAsset({
    required void Function(File?) onAssetPicked,
    required PickerAssetType pickerAssetType,
    required BuildContext context,
  }) async {
    final ImagePicker _picker = ImagePicker();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 64.0.h,
            child: Column(
              children: [
                selectResourceText(
                  text: pickerAssetType == PickerAssetType.photo
                      ? AppLocalizations.of(context)!.takeApicture
                      : AppLocalizations.of(context)!.recordVideo,
                  color: AppColors.primary,
                  onTap: () async {
                    Get.back();
                    final cameraAccessPermission = await Permission.camera.request();

                    if (cameraAccessPermission.isPermanentlyDenied) {
                      requestAccessPopup(context, _RequestAccess.camera);
                    } else {
                      var pic;
                      switch (pickerAssetType) {
                        case PickerAssetType.photo:
                          pic = await _picker.pickImage(source: ImageSource.camera);
                          break;
                        case PickerAssetType.video:
                          pic = await _picker.pickVideo(source: ImageSource.camera);
                      }

                      if (pic != null) onAssetPicked(File(pic.path));
                    }
                  },
                ),
                Divider(height: 32.0.h),
                selectResourceText(
                  text: AppLocalizations.of(context)!.openGallery,
                  color: AppColors.secondary,
                  onTap: () async {
                    Get.back();
                    final photosAccessPermission = await Permission.photos.request();

                    if (photosAccessPermission.isPermanentlyDenied) {
                      requestAccessPopup(context, _RequestAccess.galery);
                    } else {
                      var pic;
                      switch (pickerAssetType) {
                        case PickerAssetType.photo:
                          pic = await _picker.pickImage(source: ImageSource.gallery);
                          break;
                        case PickerAssetType.video:
                          pic = await _picker.pickVideo(source: ImageSource.gallery);
                      }

                      if (pic != null) onAssetPicked(File(pic.path));
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selectResourceText({required Function()? onTap, required String text, required Color color}) {
    return GestureDetector(
      child: SizedBox(
        height: 16.0.h,
        width: Get.width,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            color: color,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  void requestAccessPopup(BuildContext context, _RequestAccess requestAccess) async {
    return await showDialog(
      context: context,
      builder: (ctx) {
        final message = requestAccess == _RequestAccess.camera
            ? 'É necessário acesso a sua câmera para tirar uma foto.\n\nDeseja ir para configurações agora?'
            : 'É necessário acesso a sua galeria para selecionar uma foto.\n\nDeseja ir para configurações agora?';

        return PopUpMessage(
          confirmAction: () {
            AppSettings.openAppSettings(type: AppSettingsType.internalStorage);
            Get.back();
          },
          backGroundColor: AppColors.info,
          title: 'Solicitação de acesso',
          denyAction: () => Get.back(),
          confirmText: AppLocalizations.of(context)!.yes,
          denyText: AppLocalizations.of(context)!.no,
          message: message,
        );
      },
    );
  }
}

enum _RequestAccess {
  galery,
  camera,
}
