import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool resendButtonIsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: authController.verifyShouldShowResendEmailButton(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Spacer(),
              _topBar(),
              SizedBox(height: 32.0.h),
              _content(),
              Spacer(),
            ],
          );
        },
      ),
    );
  }

  Widget _content() {
    final String? email = tiutiuUserController.tiutiuUser.email;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headline1(),
          _headline2(email),
          SizedBox(height: 16.0.h),
          _warningMessage(),
          SizedBox(height: 16.0.h),
          _resendEmail(),
          _backButton()
        ],
      ),
    );
  }

  Widget _topBar() {
    return Column(
      children: [
        Icon(Icons.mark_email_unread_outlined, color: AppColors.primary, size: 64.0.h),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AutoSizeTexts.autoSizeText24(
            color: AppColors.primary,
            AppLocalizations.of(context)!.verifyYourEmail,
          ),
        ),
      ],
    );
  }

  AutoSizeText _headline1() {
    return AutoSizeTexts.autoSizeText16(
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
      AppLocalizations.of(context)!.linkWasSent,
    );
  }

  Widget _headline2(String? email) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeTexts.autoSizeText16(
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            color: AppColors.primary,
            email,
          ),
          AutoSizeTexts.autoSizeText16(
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            '.',
          ),
        ],
      ),
    );
  }

  Widget _resendEmail() {
    return FutureBuilder(
      future: authController.verifyShouldShowResendEmailButton(),
      builder: (context, snapshot) {
        return Obx(
          () => Visibility(
            visible: authController.allowResendEmail,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _noEmailReceived(),
                _resendButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _backButton() {
    return Visibility(
      visible: homeController.bottomBarIndex != BottomBarIndex.POST.indx,
      child: SimpleTextButton(
        textColor: AppColors.black.withOpacity(.7),
        onPressed: () => Get.back(),
        text: AppLocalizations.of(context)!.back,
      ),
    );
  }

  Widget _warningMessage() {
    return Column(
      children: [
        AutoSizeTexts.autoSizeText14(
          AppLocalizations.of(context)!.verifyEmailAdvice,
          textAlign: TextAlign.center,
        ),
        AutoSizeTexts.autoSizeText14(
          textAlign: TextAlign.center,
          AppLocalizations.of(context)!.checkYourSpam,
          color: AppColors.danger,
        ),
      ],
    );
  }

  AutoSizeText _noEmailReceived() {
    return AutoSizeTexts.autoSizeText16(
      AppLocalizations.of(context)!.dontReceiveEmail,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
    );
  }

  Widget _resendButton() {
    return Visibility(
      replacement: _loadingWidget(),
      visible: resendButtonIsEnabled,
      child: TextButton(
        child: AutoSizeTexts.autoSizeText16(
          textDecoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
          color: Colors.lightBlue,
          AppLocalizations.of(context)!.resend,
        ),
        onPressed: _onEmailResent,
      ),
    );
  }

  Future<void> _onEmailResent() async {
    String resultMessage = '';

    setState(() {
      resendButtonIsEnabled = false;
    });

    try {
      await authController.sendEmail();

      setState(() {
        resendButtonIsEnabled = true;
      });

      resultMessage = AppLocalizations.of(context)!.emailSent;
    } catch (exception) {
      resultMessage = AppLocalizations.of(context)!.unableToResendEmail;

      crashlyticsController.reportAnError(
        message: 'Could not send the email due to $exception',
        exception: exception,
      );
    }

    systemController.snackBarIsOpen = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(TiuTiuSnackBar(message: resultMessage))
        .closed
        .then((value) => systemController.snackBarIsOpen = false);

    setState(() {
      resendButtonIsEnabled = true;
    });
  }

  Widget _loadingWidget() {
    return Container(
      child: CircularProgressIndicator(strokeWidth: 1),
      margin: EdgeInsets.all(8.0.h),
      height: 12.0.h,
      width: 12.0.h,
    );
  }
}
