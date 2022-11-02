import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncerProfile extends StatelessWidget {
  AnnouncerProfile({
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
            height: Get.height / 1.4,
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
              right: 52.0,
              left: 52.0,
              top: 0.0.h,
              child: _roundedPicture(),
            ),
            Positioned(
              child: _errorImageNull(),
              right: 96.0.h,
              left: 96.0.h,
              top: 132.0.h,
            ),
          ],
        ),
        Container(
          height: Get.height / 3,
          margin: EdgeInsets.only(left: 8.0.w, top: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _userName(),
              Spacer(),
              _userLastSeen(),
              _userSinceDate(),
              Spacer(),
              _userPostsQty(),
              Spacer(),
              _contactTitle(),
              _contactButtonRow(),
              Spacer(),
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
          radius: Get.width / 4,
          onAssetRemoved: () {},
          viewOnly: true,
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
          height: Get.height / 3,
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
      style: TextStyles.fontSize16(
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _userLastSeen() {
    return SizedBox(
      height: 32.0.h,
      child: Column(
        children: [
          AutoSizeText(
            '${UserStrings.userLastSeen} ${Formatter.getFormattedDateAndTime(_user.lastLogin ?? DateTime.now().toIso8601String())}',
            style: TextStyles.fontSize(fontStyle: FontStyle.italic),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _userSinceDate() {
    return AutoSizeText(
      '${UserStrings.userSince} ${Formatter.getFormattedDate(_user.createdAt ?? DateTime.now().toIso8601String())}',
    );
  }

  Widget _userPostsQty() {
    return StreamBuilder<int>(
      initialData: 1,
      stream: tiutiuUserController.service.getUserPostsById(_user.uid!).asyncMap<int>((event) => event.docs.length),
      builder: (context, snapshot) {
        final qty = snapshot.data ?? 1;
        return AutoSizeText('$qty ${UserStrings.postsQty(qty)}');
      },
    );
  }

  Widget _contactTitle() {
    return Column(
      children: [
        Divider(),
        AutoSizeText(
          style: TextStyles.fontSize(),
          UserStrings.contact,
        ),
        Divider(),
      ],
    );
  }

  Widget _contactButtonRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ButtonWide(
              color: AppColors.secondary,
              text: AppStrings.chat,
              isToExpand: false,
              icon: Icons.phone,
              onPressed: () {},
            ),
          ),
          Expanded(
            child: ButtonWide(
              text: AppStrings.whatsapp,
              color: AppColors.primary,
              icon: Tiutiu.whatsapp,
              isToExpand: false,
              onPressed: () {
                Launcher.openWhatsApp(
                  number: Formatter.unmaskNumber(_user.phoneNumber!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
