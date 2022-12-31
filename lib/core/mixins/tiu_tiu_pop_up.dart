import 'package:tiutiu/core/widgets/popup_message.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin TiuTiuPopUp {
  Future showPopUp({
    required String message,
    bool barrierDismissible = true,
    void Function()? secondaryAction,
    void Function()? mainAction,
    bool warning = false,
    bool info = false,
    String title = 'Erro',
    bool error = false,
    String? confirmText,
    Color? textColor,
    String? denyText,
  }) async {
    return await showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopUpMessage(
          denyText: denyText ?? AppStrings.ok,
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
          warning: warning,
          error: error,
          title: title,
          info: info,
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
      secondaryAction: onCancel,
      barrierDismissible: false,
      confirmText: confirmText,
      mainAction: onRetry,
      denyText: denyText,
      message: message,
      error: true,
      title: title,
    );
  }

  Future<void> showsOnRequestSuccessPopup({
    void Function()? onDone,
    required String message,
  }) async {
    await showPopUp(
      confirmText: AppStrings.ok,
      barrierDismissible: false,
      title: AppStrings.success,
      mainAction: onDone,
      message: message,
      warning: false,
      error: false,
    );
  }
}
