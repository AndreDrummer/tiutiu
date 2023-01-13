import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InsertCodeBoxes extends StatelessWidget {
  const InsertCodeBoxes({
    required this.onChanged,
    this.onCompleted,
    this.controller,
    super.key,
  });

  final TextEditingController? controller;
  final Function(String)? onCompleted;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      autoDisposeControllers: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      appContext: context,
      obscureText: false,
      length: 6,
      pinTheme: PinTheme(
        selectedFillColor: AppColors.primary.withAlpha(100),
        inactiveFillColor: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        activeFillColor: AppColors.white,
        selectedColor: AppColors.primary,
        inactiveColor: AppColors.primary,
        shape: PinCodeFieldShape.box,
        fieldHeight: 50,
        fieldWidth: 40,
      ),
      animationDuration: Duration(milliseconds: 300),
      onCompleted: onCompleted,
      enableActiveFill: false,
      controller: controller,
      onChanged: onChanged,
      beforeTextPaste: (text) {
        return GetUtils.isNum(text ?? "");
      },
      dialogConfig: DialogConfig(
        dialogContent: AuthStrings.doYouWannaPasteCodeCopied,
        dialogTitle: AuthStrings.pasteCode,
        affirmativeText: AppStrings.yes,
        negativeText: AppStrings.no,
      ),
    );
  }
}
