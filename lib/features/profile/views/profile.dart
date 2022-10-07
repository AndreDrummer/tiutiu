import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/Widgets/my_account_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile({
    required final TiutiuUser user,
  }) : _user = user;

  final TiutiuUser _user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(
          automaticallyImplyLeading: true,
          text: _user.displayName ?? '',
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
        height: 128.0.h,
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
          height: 128.0.h,
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
    return AutoSizeText(
      '${_user.displayName}',
      style: TextStyles.fontSize24(
        fontWeight: FontWeight.w700,
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
        margin: EdgeInsets.only(bottom: 8.0.h),
        height: Get.height * .57,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          children: profileController.myProfileOptionsTile.map((title) {
            final index = profileController.myProfileOptionsTile.indexOf(title);

            return MyAccountCard(
              icon: profileController.myProfileOptionsIcon.elementAt(index),
              isToCenterText: false,
              isToExpand: true,
              onPressed: () {
                profileController.handleOptionHitted(title);
              },
              text: title,
            );
          }).toList(),
        ),
      ),
    );
  }
}
