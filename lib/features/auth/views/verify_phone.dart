import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class VerifyPhone extends StatelessWidget {
  const VerifyPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authController.verifyPhoneNumber(),
      builder: (context, snapshot) {
        return Column(
          children: [
            SizedBox(height: 32.0.h),
            _topBar(),
            SizedBox(height: 32.0.h),
            _content(context),
            Spacer(),
          ],
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final String? number = tiutiuUserController.tiutiuUser.phoneNumber;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeTexts.autoSizeText18(
            fontWeight: FontWeight.w600,
            'Insira o token enviado para o número',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeTexts.autoSizeText18(
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                color: AppColors.primary,
                number,
              ),
              AutoSizeTexts.autoSizeText18(
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
                '.',
              ),
            ],
          ),
          SizedBox(height: 16.0.h),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PinCodeTextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                selectedFillColor: AppColors.primary.withAlpha(100),
                inactiveFillColor: Colors.transparent,
                selectedColor: AppColors.primary,
                inactiveColor: Colors.green,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                activeFillColor: Colors.white,
                fieldHeight: 50,
                fieldWidth: 40,
              ),
              animationDuration: Duration(milliseconds: 300),
              controller: textEditingController,
              enableActiveFill: true,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _topBar() {
    return Column(
      children: [
        Icon(Icons.phone_android_rounded, color: AppColors.primary, size: 120.0.h),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoSizeTexts.autoSizeText24(
            color: AppColors.primary,
            'Verifique seu número',
          ),
        ),
      ],
    );
  }
}
