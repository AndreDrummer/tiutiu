import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
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
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0.h),
                  ),
                  child: _cardContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return ListView(
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
            Positioned(
              child: _errorImageNull(),
              right: 96.0.h,
              left: 96.0.h,
              top: 132.0.h,
            ),
          ],
        ),
        SizedBox(height: 8.0.h),
        SizedBox(
          height: Get.height,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            children: [
              MyAccountCard(
                icone: Icons.grid_view,
                isToCenterText: false,
                isToExpand: true,
                text: 'Meus Posts',
                textIcon: 'sadfasdfa',
                onTap: () {},
              ),
              MyAccountCard(
                icone: Icons.favorite,
                isToCenterText: false,
                isToExpand: true,
                text: 'Favoritos',
                textIcon: 'sadfasdfa',
                onTap: () {},
              ),
              MyAccountCard(
                icone: FontAwesomeIcons.comments,
                isToCenterText: false,
                isToExpand: true,
                text: 'Chat Online',
                textIcon: 'sadfasdfa',
                onTap: () {},
              ),
              MyAccountCard(
                icone: FontAwesomeIcons.gear,
                isToCenterText: false,
                isToExpand: true,
                text: 'Configurações',
                textIcon: 'sadfasdfa',
                onTap: () {},
              ),
              MyAccountCard(
                icone: FontAwesomeIcons.arrowRightFromBracket,
                isToCenterText: false,
                isToExpand: true,
                textIcon: 'sadfasdfa',
                text: 'Sair',
                onTap: () {},
              ),
            ],
          ),
        )
      ],
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

  Widget _errorImageNull() {
    return Obx(
      () => Visibility(
        visible: profileController.showErrorEmptyPic,
        child: AutoSizeText(
          MyProfileStrings.insertAPicture,
          style: TextStyles.fontSize16(
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
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
}
