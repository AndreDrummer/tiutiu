import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/widgets/button_wide_outlined.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/utils/formatter.dart';
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
  final TextEditingController codeController = TextEditingController();
  bool enableResendButton = false;
  bool codeFilled = false;
  int? _secondsToExpirate;
  Timer? _timer;

  @override
  void initState() {
    authController.verifyIfWhatsappTokenIsStillValid().then((_) => startTimer());
    super.initState();
  }

  void startTimer() {
    enableResendButton = !authController.isWhatsappTokenValid;
    _secondsToExpirate = authController.secondsToExpireCode;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(
        () {
          if (_secondsToExpirate! < 1) {
            _timer?.cancel();
            enableResendButton = true;
          } else {
            _secondsToExpirate = _secondsToExpirate! - 1;
          }
        },
      ),
    );
  }

  void restartTimer() {
    setState(() {
      _secondsToExpirate = authController.secondsToExpireCode;
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? number = tiutiuUserController.tiutiuUser.phoneNumber;

    return Scaffold(
      body: FutureBuilder(
        future: authController.verifyIfWhatsappTokenIsStillValid(),
        builder: (context, snapshot) {
          return ListView(
            children: [
              _topBar(),
              _insertCodeSentToTheNumberText(number),
              _codeBoxes(context),
              SizedBox(
                height: Get.width /
                    Dimensions.getDimensBasedOnDeviceHeight(
                      bigger: 2.5,
                      medium: 2.2,
                      smaller: 8,
                    ),
              ),
              _resendWithin(),
              _confirmButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _topBar() {
    return Obx(
      () => Column(
        children: [
          AnimatedContainer(
            height: authController.numberVerified ? Get.width / 3 : 48.0.h,
            duration: Duration(milliseconds: 500),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            child: Icon(
              authController.numberVerified ? Icons.verified_user : FontAwesomeIcons.whatsapp,
              size: authController.numberVerified ? 96.0.h : 64.0.h,
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AutoSizeTexts.autoSizeText24(
              authController.numberVerified ? AuthStrings.numberVerified : AuthStrings.verifyYourNumber,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insertCodeSentToTheNumberText(String? number) {
    return Visibility(
      visible: !authController.numberVerified,
      child: Column(
        children: [
          SizedBox(height: 32.0.h),
          AutoSizeTexts.autoSizeText18(
            authController.isWhatsappTokenValid
                ? AuthStrings.insertCodeSentToNumber
                : AuthStrings.weWilSendACodeToThisNumber,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0.h),
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
          Visibility(
            replacement: SizedBox(height: 16.0.h),
            visible: !authController.isWhatsappTokenValid,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: AutoSizeTexts.autoSizeText14(
                AuthStrings.confirmeIfThisNumberIsCorrect,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeBoxes(
    BuildContext context,
  ) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: authController.numberVerified ? 0 : 1,
      child: Visibility(
        visible: !authController.numberVerified,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PinCodeTextField(
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
            controller: codeController,
            enableActiveFill: true,
            onCompleted: (v) {
              setState(() {
                codeFilled = true;
              });
            },
            onChanged: (value) {
              if (value.length < 6) {
                setState(() {
                  codeFilled = false;
                });
              }
            },
            beforeTextPaste: (text) {
              return GetUtils.isNum(text ?? "");
            },
            dialogConfig: DialogConfig(
              dialogContent: AuthStrings.doYouWannaPasteCodeCopied,
              dialogTitle: AuthStrings.pasteCode,
              affirmativeText: AppStrings.yes,
              negativeText: AppStrings.no,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resendWithin() {
    return Visibility(
      visible: !authController.numberVerified,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: !codeFilled ? 1 : 0,
        child: Visibility(
          visible: authController.isWhatsappTokenValid,
          replacement: _resendButton(),
          child: Column(
            children: [
              AutoSizeTexts.autoSizeText14(
                AuthStrings.codeIsValidForMinutes,
                fontWeight: FontWeight.w300,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                child: AutoSizeTexts.autoSizeText14(
                  '${AppStrings.wait} ${Formatters.timeSecondsFormmated(_secondsToExpirate ?? 0)} para receber outro código',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resendButton() {
    return Column(
      children: [
        Visibility(
          visible: !codeFilled,
          child: ButtonWide(
            isToExpand: true,
            onPressed: () async {
              await authController.sendWhatsAppCode();
              restartTimer();
            },
            text: AuthStrings.confirmAndReceiveCode,
          ),
        ),
        Visibility(
          visible: !codeFilled,
          child: OutlinedButtonWide(
            onPressed: () async {
              Get.toNamed(Routes.settings);
            },
            text: AuthStrings.editPhoneNumber,
          ),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return Column(
      children: [
        AnimatedOpacity(
          duration: Duration(seconds: 0),
          opacity: (codeFilled || authController.numberVerified) ? 1 : 0,
          child: Visibility(
            replacement: CircularProgressIndicator(),
            visible: !authController.numberVerified,
            child: ButtonWide(
              onPressed: () {
                authController.whatsAppCodeIsValid(codeController.text).then((valid) {
                  if (!valid) {
                    appController.snackBarIsOpen = true;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                          SnackBar(
                            content: AutoSizeTexts.autoSizeText14(authController.feedbackText),
                            backgroundColor: valid ? AppColors.success : AppColors.danger,
                          ),
                        )
                        .closed
                        .then((value) => appController.snackBarIsOpen = false);
                    codeController.clear();
                  } else {
                    Future.delayed(Duration(seconds: 2)).then((value) => authController.continueAfterValidateNumber());
                  }
                });
              },
              text: authController.numberVerified ? AppStrings.contines : AuthStrings.validate,
            ),
          ),
        ),
        SizedBox(height: authController.numberVerified ? 64.0.h : 16.0.h),
      ],
    );
  }
}
