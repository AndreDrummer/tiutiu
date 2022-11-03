import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.0.h),
        _topBar(),
        SizedBox(height: 64.0.h),
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
          AutoSizeTexts.autoSizeText18(
            fontWeight: FontWeight.w600,
            'Um link de verificação de conta foi enviado',
            textAlign: TextAlign.center,
          ),
          Row(
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
          ),
          SizedBox(height: 16.0.h),
          AutoSizeTexts.autoSizeText14(
            fontWeight: FontWeight.w400,
            'Somente contas verificadas podem publicar um anúncio. Cheque sua caixa de spam se necessário.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeTexts.autoSizeText16(
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                'Não recebeu um email?',
              ),
              SizedBox(width: 4.0.h),
              AutoSizeTexts.autoSizeText16(
                textDecoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: Colors.lightBlue,
                'Reenviar',
              ),
              AutoSizeTexts.autoSizeText16(
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                '.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Column(
      children: [
        Icon(Icons.mark_email_unread_outlined, color: AppColors.primary, size: 120.0.h),
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
}
