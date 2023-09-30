import 'package:tiutiu/features/support/models/support_us.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class SupportUs extends StatelessWidget {
  const SupportUs({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: FutureBuilder<SupportUsData>(
          future: supportUsController.getSupportUsData(),
          builder: (context, snapshot) {
            return AsyncHandler<SupportUsData>(
              snapshot: snapshot,
              buildWidget: (supportUsData) {
                final backgroundImages = supportUsData.backgroundImages;

                return Stack(
                  children: [
                    Container(
                      child: AssetHandle.getImage(backgroundImages.elementAt(Random().nextInt(3))),
                      decoration: BoxDecoration(color: AppColors.black),
                      alignment: Alignment.center,
                      height: Get.height,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: Get.height,
                      child: Column(
                        children: [
                          Spacer(),
                          _copyKey(context, supportUsData),
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
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _copyKey(BuildContext context, SupportUsData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _keyPix(data.pixKey, data.keyType),
        _copyKeyButton(context: context, key: data.pixKey),
        _pixWarningMessage(data.warningMessage),
      ],
    );
  }

  Widget _keyPix(String key, String keyType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          child: AutoSizeTexts.autoSizeText10(
            color: AppColors.white,
            keyType,
          ),
          padding: EdgeInsets.only(left: 12.0.w, bottom: 2.0.h),
        ),
        AutoSizeTexts.autoSizeText16(
          key.isNotEmptyNeighterNull() ? key : '42.510.947/0001-92',
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w900,
          color: AppColors.white,
        ),
      ],
    );
  }

  ButtonWide _copyKeyButton({required BuildContext context, required String key}) {
    return ButtonWide(
      color: AppColors.secondary,
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: key)).then(
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              TiuTiuSnackBar(message: AppLocalizations.of(context)!.keyPixCopied),
            );
          },
        );
      },
      text: AppLocalizations.of(context)!.copyKey,
      icon: Icons.copy,
      rounded: false,
    );
  }

  Padding _pixWarningMessage(String pixWarning) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.0.w, top: 4.0.h),
      child: AutoSizeTexts.autoSizeText12(
        pixWarning,
        color: AppColors.white,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
