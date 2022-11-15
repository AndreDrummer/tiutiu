import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/popup_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin TiuTiuPopUp {
  Future showPopUp({
    required String message,
    bool barrierDismissible = true,
    void Function()? secondaryAction,
    void Function()? mainAction,
    bool warning = false,
    String title = 'Erro',
    bool danger = false,
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
          error: danger,
          title: title,
        );
      },
    );
  }
}
