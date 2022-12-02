import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'dart:math';

class SupportUs extends StatelessWidget {
  const SupportUs({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundImages = [
      DonateAssets.donate1,
      DonateAssets.donate2,
      DonateAssets.donate3,
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              height: Get.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetHandle.imageProvider(backgroundImages.elementAt(Random().nextInt(3))),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Spacer(),
                  _copyKey(),
                  SizedBox(height: 16.0.h),
                ],
              ),
            ),
            Positioned(
              child: BackButton(
                color: AppColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _copyKey() {
    final String pixWarning =
        '<p><b>Aviso:</b> O PIX será destinado a <b>Anja Solutions</b>, empresa que mantém o app ou ao seu sócio <b>André Felipe</b>.</p>';

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
          child: AutoSizeTexts.autoSizeText10(
            SupportUsStrings.keyPIX,
            color: AppColors.white,
          ),
          padding: EdgeInsets.only(left: 12.0.w, bottom: 8.0.h),
        ),
        AutoSizeTexts.autoSizeText16(
          key,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w900,
          color: AppColors.white,
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
            fontWeight: FontWeight.w300,
            fontSize: FontSize.small,
            margin: EdgeInsets.zero,
            color: AppColors.white,
          ),
        },
      ),
    );
  }
}
