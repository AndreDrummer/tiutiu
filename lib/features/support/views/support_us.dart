import 'package:tiutiu/features/talk_with_us/widgets/body_card.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/play_store_rating.dart';
import 'package:tiutiu/core/widgets/app_name_widget.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class SupportUs extends StatelessWidget {
  const SupportUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: SupportUsStrings.helpMaintainTheApp),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetHandle.imageProvider(ImageAssets.bones2),
            fit: BoxFit.cover,
          ),
        ),
        child: BodyCard(
          bodyHeight: Get.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.0.h),
              _messageWidget(),
              SizedBox(height: 24.0.h),
              _copyKey(),
              Spacer(),
              _rateUs(),
            ],
          ),
        ),
      ),
    );
  }

  Column _messageWidget() {
    final String message =
        '<p>tem altos gastos mensais com hospedagem de dados para que se mantenha ativo 24 horas por dia e 7 dias por semana nas plataformas digitais como a <em>${Platform.isAndroid ? 'Play Store' : 'Apple Store'}</em> para que consiga entregar <em>facilidade, praticidade e fluidez</em> no momento de escolher seu melhor amigo.<br/><br/>Se você gosta da forma como fazemos isso, <b>considere fazer-nos uma doação!</b><br/><br/>Seremos gratos por sua atitude e <b>nossos amigos peludinhos</b> ainda mais.</p';

    return Column(
      children: [
        Row(
          children: [
            AutoSizeTexts.autoSizeText10('     O ', fontWeight: FontWeight.w300),
            AppNameWidget(letterSpacing: 1, fontSize: 12.sp),
            AutoSizeTexts.autoSizeText20(',', fontWeight: FontWeight.w300),
          ],
        ),
        Html(
          data: message,
          style: {
            'p': Style(textAlign: TextAlign.justify, margin: EdgeInsets.zero),
          },
        ),
      ],
    );
  }

  Widget _copyKey() {
    final String pixWarning =
        '<p>O PIX será destinado a <b>Anja Solutions</b>, empresa que mantém o app ou de um de seus sócios.</p>';

    return FutureBuilder<String>(
      future: supportUsController.getPixKey(),
      builder: (context, snapshot) {
        final key = snapshot.data ?? '42.510.947/0001-92';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _keyPix(key),
            _copyKeyButton(context: context, key: key),
            _pixWarningMessage(pixWarning),
          ],
        );
      },
    );
  }

  Widget _keyPix(String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          child: AutoSizeTexts.autoSizeText10(SupportUsStrings.keyPIX),
          padding: EdgeInsets.only(left: 10.0.w, bottom: 4.0.h),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0.h),
          child: AutoSizeTexts.autoSizeText16(
            key,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  ButtonWide _copyKeyButton({required BuildContext context, required String key}) {
    return ButtonWide(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: key)).then(
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(SupportUsStrings.keyPixCopied),
              ),
            );
          },
        );
      },
      text: SupportUsStrings.copyKey,
      icon: Icons.copy,
      rounded: false,
    );
  }

  Padding _pixWarningMessage(String pixWarning) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: Html(
        data: pixWarning,
        style: {
          'p': Style(
            fontSize: FontSize.small,
            fontWeight: FontWeight.w300,
          ),
        },
      ),
    );
  }

  Column _rateUs() {
    return Column(
      children: [
        Divider(color: AppColors.secondary),
        RatingUs(),
        Divider(color: AppColors.secondary),
      ],
    );
  }
}
