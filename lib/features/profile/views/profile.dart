import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/my_account_card.dart';
import 'package:tiutiu/core/widgets/avatar_profile.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

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
        height: Get.width / 3,
        child: Column(
          children: [
            Stack(
              children: [
                _backgroundImage(),
                Positioned(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _roundedPicture(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.0.h, left: 8.0.w),
                        child: _userName(),
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
        margin: EdgeInsets.symmetric(vertical: 12.0.h),
        alignment: Alignment.center,
        child: AvatarProfile(
          onAssetPicked: (file) {},
          avatarPath: _user.avatar,
          onAssetRemoved: () {},
          viewOnly: true,
          radius: 32.0.h,
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
          height: Get.width / 3,
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
        Formatters.cuttedText('${_user.displayName}', size: 32),
        fontWeight: FontWeight.w700,
      ),
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
        height: _cardHeight(),
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
                } else if (title == MyProfileOptionsTile.deleteAccount) {
                  _deleteAccount(title);
                } else {
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

  Future<void> _deleteAccount(String title) async {
    String? lastLoginTime = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.lastLoginTime);
    lastLoginTime ??= DateTime.now().toIso8601String();
    final lastLoginDateTime = DateTime.parse(lastLoginTime);

    String popUpMessage = '';
    String popUpTitle = '';

    final loginTimeOver2Minutes = DateTime.now().difference(lastLoginDateTime).inMinutes >= 2;

    if (loginTimeOver2Minutes) {
      popUpMessage = AuthStrings.demandRecentLoginWarning;
      popUpTitle = AuthStrings.doLogin;
    } else {
      popUpMessage = AuthStrings.deleteAccountWarning;
      popUpTitle = AuthStrings.deleteAccount;
    }

    await showPopUp(
      secondaryAction: () {
        Get.back();
        loginTimeOver2Minutes
            ? profileController.handleOptionHitted(MyProfileOptionsTile.leave)
            : profileController.handleOptionHitted(title);
      },
      warning: loginTimeOver2Minutes,
      danger: !loginTimeOver2Minutes,
      confirmText: AppStrings.yes,
      barrierDismissible: false,
      denyText: AppStrings.no,
      message: popUpMessage,
      mainAction: Get.back,
      title: popUpTitle,
    );
  }

  double _cardHeight() => Platform.isIOS ? Get.height * .62 : Get.height * .64;
}
