import 'dart:math';

import 'package:dio/dio.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/Widgets/my_account_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget with TiuTiuPopUp {
  Profile({
    required final TiutiuUser user,
  }) : _user = user;

  final TiutiuUser _user;

  @override
  Widget build(BuildContext context) {
    bool _itsMe = _user.uid == tiutiuUserController.tiutiuUser.uid;

    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(
          automaticallyImplyLeading: true,
          text: _itsMe ? MyProfileStrings.myProfile : _user.displayName ?? '',
        ),
        body: Container(
          margin: EdgeInsets.only(
            right: 8.0.w,
            left: 8.0.w,
            top: 8.0.w,
          ),
          height: Get.height,
          child: ListView(
            children: [
              _cardHeader(context),
              _cardBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardHeader(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0.h),
          topLeft: Radius.circular(12.0.h),
        ),
      ),
      child: SizedBox(
        height: Get.width / 2.5,
        child: ListView(
          children: [
            Stack(
              children: [
                _backgroundImage(),
                Positioned(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _roundedPicture(),
                      Padding(
                        padding: EdgeInsets.only(top: 36.0.h, left: 8.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _userName(),
                            SizedBox(height: 4.0.h),
                            _userSinceDate(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  left: 16.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundedPicture() {
    return GestureDetector(
      onTap: () {
        fullscreenController.openFullScreenMode([_user.avatar]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0.h),
        alignment: Alignment.center,
        child: AvatarProfile(
          onAssetPicked: (file) {},
          avatarPath: _user.avatar,
          onAssetRemoved: () {},
          viewOnly: true,
          radius: 48.0.h,
        ),
      ),
    );
  }

  Opacity _backgroundImage() {
    return Opacity(
      opacity: .3,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0.h),
          topLeft: Radius.circular(12.0.h),
        ),
        child: Container(
          height: Get.width / 2.5,
          width: double.infinity,
          child: ClipRRect(
            child: Image.asset(
              ImageAssets.bones2,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }

  Widget _userName() {
    return Container(
      width: 200.0.w,
      child: AutoSizeTexts.autoSizeText24(
        fontWeight: FontWeight.w700,
        '${_user.displayName}',
      ),
    );
  }

  Widget _userSinceDate() {
    return AutoSizeText(
      '${UserStrings.userSince} ${Formatter.getFormattedDate(_user.createdAt ?? DateTime.now().toIso8601String())}',
    );
  }

  Widget _cardBody() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12.0.h),
          bottomLeft: Radius.circular(12.0.h),
        ),
      ),
      child: Container(
        height: Get.height * .55,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          children: profileController.myProfileOptionsTile.map((title) {
            final index = profileController.myProfileOptionsTile.indexOf(title);

            return MyAccountCard(
              icon: profileController.myProfileOptionsIcon.elementAt(index),
              isToCenterText: false,
              isToExpand: true,
              onPressed: () {
                if (title == MyProfileOptionsTile.leave) {
                  _exitApp(title);
                } else {
                  print('Opcao');
                  testWhatsapp(code: generateCode());
                  profileController.handleOptionHitted(title);
                }
              },
              text: title,
            );
          }).toList(),
        ),
      ),
    );
  }

  String generateCode() {
    String code = '';
    for (int i = 0; i < 6; i++) {
      final digit = Random().nextInt(9);
      code += '$digit';
    }
    return code;
  }

  Future<void> _exitApp(String title) async {
    await showPopUp(
      message: AppStrings.wannaLeave,
      confirmText: AppStrings.yes,
      mainAction: () {
        Get.back();
      },
      secondaryAction: () {
        Get.back();
        profileController.handleOptionHitted(title);
      },
      barrierDismissible: false,
      title: AppStrings.leave,
      denyText: AppStrings.no,
      warning: true,
      danger: false,
    );
  }

  Future testWhatsapp({String phoneNumber = '62994670169', String code = '123456'}) async {
    final _dio = Dio();

    final token =
        'EAALNROzeMskBANZAZCUroigNbvxxIZApQ0v9t1GkHKg4qeZBOokqemM5ZCrCx8yTBFgcZAwZA06aRzI2nZAWfB7yyOPPOmHBxdzzTTIFZAyxBNS4i6kNIvsbpPjZBk4lVLIC9kZCDYx61M9ZAs4eheiZC2YjYEB1zPUMILOttCQz1uVaAZBlMrYuO8KmCkE1rZC30uITyTxQwO75EeBGWV4SObGMU3p';

    final templateProd = 'tiutiu_whatsapp_token_code_prod';
    final numberIdProd = '100356716232975';

    final templateTest = 'tiutiu_whatsapp_token_code';
    final numberIdTest = '108901298698499';

    final template = templateTest;
    // final template = templateProd;

    final numberId = numberIdTest;
    // final numberId = numberIdProd;

    final headers = {'Authorization': 'Bearer $token'};

    final body = {
      "messaging_product": "whatsapp",
      "to": "55$phoneNumber",
      "type": "template",
      "template": {
        "name": "$template",
        "language": {"code": "pt_BR"},
        "components": [
          {
            "type": "body",
            "parameters": [
              {
                "type": "text",
                "text": "$code",
              }
            ]
          }
        ]
      }
    };

    try {
      _dio.post(
        'https://graph.facebook.com/v15.0/$numberId/messages',
        data: body,
        options: Options(
          contentType: 'application/json',
          headers: headers,
        ),
      );
    } on Exception catch (error) {
      debugPrint('Error sending WhatsApp Message: $error');
    }
  }
}
