import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/popup_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin TiuTiuPopUp {
  Future showPopUp({
    void Function()? secondaryAction,
    bool barrierDismissible = true,
    void Function()? mainAction,
    required String message,
    Color? backGroundColor,
    String title = 'Erro',
    String? confirmText,
    Color? textColor,
    String? denyText,
  }) async {
    return await showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopUpMessage(
          denyText: denyText ?? AppLocalizations.of(context)!.ok,
          backGroundColor: backGroundColor,
          confirmText: confirmText ?? '',
          confirmAction: secondaryAction,
          textColor: textColor,
          denyAction: () {
            if (mainAction != null) {
              mainAction();
            } else {
              Get.back();
            }
          },
          message: message,
          title: title,
        );
      },
    );
  }

  Future<void> showsOnRequestErrorPopup({
    void Function()? onCancel,
    void Function()? onRetry,
    required String message,
    required String title,
    String? confirmText,
    String? denyText,
  }) async {
    await showPopUp(
      backGroundColor: AppColors.danger,
      secondaryAction: onCancel,
      barrierDismissible: false,
      confirmText: confirmText,
      mainAction: onRetry,
      denyText: denyText,
      message: message,
      title: title,
    );
  }

  Future<void> showsOnRequestSuccessPopup({
    required BuildContext context,
    void Function()? onDone,
    required String message,
  }) async {
    await showPopUp(
      confirmText: AppLocalizations.of(context)!.ok,
      barrierDismissible: false,
      title: AppLocalizations.of(context)!.success,
      mainAction: onDone,
      message: message,
    );
  }

  Future<void> showsDennouncePopup({required Widget content}) async {
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0.h)),
          child: content,
        );
      },
    );
  }
}
