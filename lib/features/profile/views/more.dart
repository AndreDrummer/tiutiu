import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/my_account_card.dart';
import 'package:tiutiu/core/widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

late TiutiuUser _user;

class More extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    _user = tiutiuUserController.tiutiuUser;

    return AuthenticatedArea(
      child: SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.all(4.0.h),
            child: _cardContent(context),
            height: Get.height,
          ),
        ),
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0.h)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _cardHeader(),
          _cardBody(),
        ],
      ),
    );
  }

  Widget _cardHeader() {
    return SizedBox(
      height: Get.width / 3,
      child: Stack(
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
          topRight: Radius.circular(8.0.h),
          topLeft: Radius.circular(8.0.h),
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
      child: Obx(
        () => AutoSizeTexts.autoSizeText24(
          Formatters.cuttedText('${tiutiuUserController.tiutiuUser.displayName}', size: 32),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _cardBody() {
    final myProfileOptionsTile = moreController.myProfileOptionsTile;

    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      height: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: Get.width * 1.13,
        medium: Get.width * 1.4,
        bigger: Get.width * 1.5,
      ),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 1.0.w),
        children: myProfileOptionsTile.map((title) {
          final index = myProfileOptionsTile.indexOf(title);
          final lastIndex = index == myProfileOptionsTile.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: lastIndex ? 1.0.h : 0.0.h),
            child: MoreCardOption(
              icon: moreController.myProfileOptionsIcon.elementAt(index),
              isToCenterText: false,
              isToExpand: true,
              onPressed: () {
                if (title == MyProfileOptionsTile.leave) {
                  _exitApp(title);
                } else if (title == MyProfileOptionsTile.deleteAccount) {
                  _deleteAccount(title);
                } else {
                  moreController.handleOptionHitted(title);
                }
              },
              text: title,
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _exitApp(String title) async {
    await showPopUp(
      message: AppStrings.wannaLeave,
      confirmText: AppStrings.yes,
      textColor: AppColors.black,
      mainAction: () {
        Get.back();
      },
      secondaryAction: () {
        Get.back();
        moreController.handleOptionHitted(title);
      },
      backGroundColor: AppColors.warning,
      barrierDismissible: false,
      title: AppStrings.leave,
      denyText: AppStrings.no,
    );
  }

  Future<void> _deleteAccount(String title) async {
    final canDeleteAccount = await deleteAccountController.canDeleteAccount();

    if (!canDeleteAccount)
      await deleteAccountController.showDeleteAccountLogoutWarningPopup();
    else
      moreController.handleOptionHitted(title);
  }
}
