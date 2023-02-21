import 'package:tiutiu/features/auth/widgets/insert_code_boxes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/widgets/button_wide_outlined.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/utils/formatter.dart';
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
  bool hasError = false;
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
      (timer) {
        if (mounted) {
          setState(
            () {
              if (_secondsToExpirate! < 1) {
                _timer?.cancel();
                enableResendButton = true;
              } else {
                _secondsToExpirate = _secondsToExpirate! - 1;
              }
            },
          );
        }
      },
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
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? number = Formatters.removeParaenthesisFromNumber(tiutiuUserController.tiutiuUser.phoneNumber);
    final String? countryCode = tiutiuUserController.tiutiuUser.countryCode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: authController.verifyIfWhatsappTokenIsStillValid(),
        builder: (context, snapshot) {
          return Column(
            children: [
              _topBar(),
              _insertCodeSentToTheNumberText(countryCode, number),
              _codeBoxes(context),
              _incorretCodeText(),
              Spacer(),
              _confirmButton(),
              _resendWithin(),
              SizedBox(height: Get.height < 700 ? 56.0.h : 48.0.h)
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
              authController.numberVerified
                  ? AppLocalizations.of(context).numberVerified
                  : AppLocalizations.of(context).verifyYourNumber,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insertCodeSentToTheNumberText(String? countryCode, String? number) {
    return Visibility(
      visible: !authController.numberVerified,
      child: Column(
        children: [
          SizedBox(height: 8.0.h),
          Visibility(
            visible: countryCode == '+55',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tips_and_updates, size: 10.0.h, color: AppColors.secondary),
                    SizedBox(width: 4.0.w),
                    AutoSizeTexts.autoSizeText14(
                      AppLocalizations.of(context).friendlyReminderToAdd9Digit,
                      textAlign: TextAlign.center,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                SizedBox(height: 8.0.h),
              ],
            ),
          ),
          AutoSizeTexts.autoSizeText18(
            authController.isWhatsappTokenValid
                ? AppLocalizations.of(context).insertCodeSentToNumber
                : AppLocalizations.of(context).weWilSendACodeToThisNumber,
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
                '$countryCode $number',
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
                AppLocalizations.of(context).confirmeIfThisNumberIsCorrect,
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
      opacity: authController.numberVerified ? 0 : 1,
      duration: Duration(milliseconds: 500),
      child: Visibility(
        visible: !authController.numberVerified && authController.isWhatsappTokenValid,
        child: Padding(
          child: InsertCodeBoxes(
            onCompleted: (v) {
              setState(() {
                codeFilled = true;
              });
            },
            onChanged: (value) {
              if (value.length < 6) {
                setState(() {
                  hasError = false;
                  codeFilled = false;
                });
              }
            },
            controller: codeController,
          ),
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }

  Widget _incorretCodeText() {
    return Visibility(
      visible: hasError,
      child: AutoSizeTexts.autoSizeText12(
        AppLocalizations.of(context).invalidCode,
        color: AppColors.danger,
      ),
    );
  }

  Widget _resendWithin() {
    return Visibility(
      visible: !authController.numberVerified && !codeFilled,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: !codeFilled ? 1 : 0,
        child: Visibility(
          visible: authController.isWhatsappTokenValid,
          replacement: _resendButton(),
          child: SizedBox(
            height: 72.0.h,
            child: Column(
              children: [
                AutoSizeTexts.autoSizeText14(
                  AppLocalizations.of(context).codeIsValidForMinutes,
                  fontWeight: FontWeight.w300,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                  child: AutoSizeTexts.autoSizeText14(
                    '${AppLocalizations.of(context).wait} ${Formatters.timeSecondsFormmated(_secondsToExpirate ?? 0)} ${AppLocalizations.of(context).toReceiveAnotherCode}',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
            text: AppLocalizations.of(context).confirmAndReceiveCode,
          ),
        ),
        Visibility(
          visible: !codeFilled,
          child: OutlinedButtonWide(
            onPressed: () async {
              Get.toNamed(Routes.editProfile);
            },
            text: AppLocalizations.of(context).editPhoneNumber,
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
                    systemController.snackBarIsOpen = true;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                          TiuTiuSnackBar(
                            color: valid ? AppColors.success : AppColors.danger,
                            message: authController.feedbackText,
                          ),
                        )
                        .closed
                        .then((value) => systemController.snackBarIsOpen = false);
                    codeController.clear();
                    setState(() {
                      hasError = true;
                    });
                  } else {
                    Future.delayed(Duration(seconds: 2)).then((_) {
                      authController.continueAfterValidateNumber();
                    });
                  }
                });
              },
              text: authController.numberVerified
                  ? AppLocalizations.of(context).contines
                  : AppLocalizations.of(context).validate,
            ),
          ),
        ),
        SizedBox(height: authController.numberVerified ? 64.0.h : 16.0.h),
      ],
    );
  }
}
