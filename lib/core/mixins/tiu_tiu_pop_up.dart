import 'package:tiutiu/Widgets/popup_message.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin TiuTiuPopUp {
  Future showPopUp(
    BuildContext context,
    String message, {
    bool barrierDismissible = true,
    void Function()? secondaryAction,
    void Function()? mainAction,
    bool warning = false,
    String title = 'Erro',
    bool danger = false,
    String? confirmText,
    String? denyText,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopUpMessage(
          denyText: denyText ?? AppStrings.ok,
          confirmText: confirmText ?? '',
          confirmAction: secondaryAction,
          denyAction: () {
            if (mainAction != null) {
              mainAction();
            } else {
              Get.back();
            }
          },
          title: title,
          message: message,
          error: danger,
          warning: warning,
        );
      },
    );
  }
}
