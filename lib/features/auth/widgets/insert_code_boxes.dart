import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        inactiveFillColor: AppColors.primary,
        borderRadius: BorderRadius.circular(5),
        selectedColor: AppColors.secondary,
        activeColor: AppColors.primary,
        inactiveColor: Colors.grey,
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
        dialogContent: AppLocalizations.of(context)!.doYouWannaPasteCodeCopied,
        dialogTitle: AppLocalizations.of(context)!.pasteCode,
        affirmativeText: AppLocalizations.of(context)!.yes,
        negativeText: AppLocalizations.of(context)!.no,
      ),
    );
  }
}
