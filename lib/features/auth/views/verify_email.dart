import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    return Column(
      children: [
        Spacer(),
        _topBar(),
        SizedBox(height: 32.0.h),
        _content(),
        Spacer(),
      ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _noEmailReceived(),
              _resendButton(),
            ],
          ),
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
            'Verifique seu e-mail',
          ),
        ),
      ],
    );
  }

  AutoSizeText _headline1() {
    return AutoSizeTexts.autoSizeText18(
      fontWeight: FontWeight.w600,
      'Um link de verificação foi enviado',
      textAlign: TextAlign.center,
    );
  }

  Row _headline2(String? email) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeTexts.autoSizeText18(
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
          'para o email ',
        ),
        AutoSizeTexts.autoSizeText18(
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          color: AppColors.primary,
          email,
        ),
        AutoSizeTexts.autoSizeText18(
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          '.',
        ),
      ],
    );
  }

  AutoSizeText _warningMessage() {
    return AutoSizeTexts.autoSizeText14(
      fontWeight: FontWeight.w300,
      'Somente contas verificadas podem publicar um anúncio. Cheque sua caixa de spam se necessário.',
      textAlign: TextAlign.center,
    );
  }

  AutoSizeText _noEmailReceived() {
    return AutoSizeTexts.autoSizeText16(
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
      'Não recebeu um email?',
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
          'Reenviar',
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
      print(authController.user?.email);
      await authController.user?.sendEmailVerification();
      resultMessage = 'E-mail enviado!';
    } catch (exception) {
      setState(() {
        resendButtonIsEnabled = true;
      });

      resultMessage = 'Não foi possível reenviar o e-mail. Tente novamente mais tarde!';
      debugPrint('>> Could not send the email due to $exception');
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(resultMessage),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          Get.back();
        },
      ),
    ));

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
