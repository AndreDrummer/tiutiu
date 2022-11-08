import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tiutiu/Widgets/cancel_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({super.key});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  int? _secondsToExpirate;
  Timer? _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _secondsToExpirate = authController.secondsToExpireCode;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(
        () {
          if (_secondsToExpirate! < 1) {
            _timer!.cancel();
          } else {
            _secondsToExpirate = _secondsToExpirate! - 1;
          }
        },
      ),
    );
  }

  String formatClock(int seconds) {
    var min = seconds ~/ 60;
    var sec = seconds % 60;
    if (min == 0) {
      return '$sec\s';
    } else {
      return '$min min $sec seg ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final String? number = tiutiuUserController.tiutiuUser.phoneNumber;

    return FutureBuilder(
      future: authController.verifyPhoneNumber(),
      builder: (context, snapshot) {
        return Column(
          children: [
            SizedBox(height: 48.0.h),
            _topBar(),
            SizedBox(height: 32.0.h),
            _insertCodeSentToTheNumberText(number),
            SizedBox(height: 16.0.h),
            _codeBoxes(context, textEditingController),
            Spacer(),
            _resendWithin(),
            Spacer(),
            _resendButton(),
            Spacer(),
          ],
        );
      },
    );
  }

  Widget _resendButton() {
    return Obx(
      () => SimpleTextButton(
        onPressed: authController.isWhatsappTokenStillValid ? null : authController.verifyPhoneNumber,
        textColor: AppColors.primary,
        text: 'Reenviar',
        fontSize: 16,
      ),
    );
  }

  Column _resendWithin() {
    return Column(
      children: [
        AutoSizeTexts.autoSizeText14(
          'O código é valido por 5 minutos.',
          fontWeight: FontWeight.w300,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          child: AutoSizeTexts.autoSizeText14(
            'Aguarde ${formatClock(_secondsToExpirate!)} para receber outro código',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Padding _codeBoxes(BuildContext context, TextEditingController textEditingController) {
    return Padding(
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
          return true;
        },
      ),
    );
  }

  Column _insertCodeSentToTheNumberText(String? number) {
    return Column(
      children: [
        AutoSizeTexts.autoSizeText18(
          fontWeight: FontWeight.w600,
          'Insira o código enviado para o número',
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
      ],
    );
  }

  void onResendToken() {}

  Widget _topBar() {
    return Column(
      children: [
        Icon(FontAwesomeIcons.whatsapp, color: AppColors.primary, size: 64.0.h),
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
