import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/underline_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile({
    this.isCompletingProfile = false,
    this.isEditiingProfile = false,
    TiutiuUser? user,
  }) : _user = user ?? tiutiuUserController.tiutiuUser;

  final bool isCompletingProfile;
  final bool isEditiingProfile;
  final TiutiuUser _user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(
          text: isEditiingProfile
              ? MyProfileStrings.editProfile
              : isCompletingProfile
                  ? MyProfileStrings.completeProfile
                  : _user.displayName ?? '',
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: (isCompletingProfile || isEditiingProfile)
                ? Get.height / 1.65
                : Get.height / 1.4,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0.h),
              ),
              child: _cardContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardContent() {
    return ListView(
      children: [
        Stack(
          children: [
            _backgroundImage(),
            Positioned(
              right: 52.0,
              left: 52.0,
              top: 8.0.h,
              child: _roundedPicture(),
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
              _userPhoneNumber(),
              Spacer(),
              _allowContactViaWhatsApp(),
              Spacer(),
              _userPostsQty(),
              Spacer(),
              _contactTitle(),
              _contactButtonRow(),
            ],
          ),
        )
      ],
    );
  }

  Widget _roundedPicture() {
    return GestureDetector(
      onTap: () {
        if (!_itsMe) fullscreenController.openFullScreenMode([_user.avatar]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0.h),
        alignment: Alignment.center,
        child: Obx(
          () => AvatarProfile(
            onAssetPicked: (file) {
              tiutiuUserController.updateTiutiuUser(
                TiutiuUserEnum.avatar,
                file,
              );
            },
            userName: '${tiutiuUserController.tiutiuUser.displayName}',
            avatarPath: tiutiuUserController.tiutiuUser.avatar,
            radius: _itsMe ? Get.width / 6 : Get.width / 4,
            onAssetRemoved: () {
              tiutiuUserController.updateTiutiuUser(
                TiutiuUserEnum.avatar,
                null,
              );
            },
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
          height: _itsMe ? Get.width / 2 : Get.height / 3,
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
    return UnderlineInputText(
      onChanged: (name) {
        tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.displayName, name);
      },
      labelText: _itsMe ? MyProfileStrings.howCallYou : '',
      initialValue: _user.displayName,
      fontSizeLabelText: 16.0.h,
    );
  }

  Widget _userPhoneNumber() {
    return Visibility(
      visible: _itsMe,
      child: Column(
        children: [
          SizedBox(height: 16.0.h),
          UnderlineInputText(
            onChanged: (number) {
              tiutiuUserController.updateTiutiuUser(
                TiutiuUserEnum.phoneNumber,
                number,
              );
            },
            labelText: _itsMe ? MyProfileStrings.whatsapp : '',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            initialValue: _user.phoneNumber,
            fontSizeLabelText: 16.0.h,
          ),
        ],
      ),
    );
  }

  Widget _allowContactViaWhatsApp() {
    return Visibility(
      visible: _itsMe,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.h,
          horizontal: 16.0.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              UserStrings.allowContactViaWhatsApp,
              style: TextStyles.fontSize14(),
            ),
            Transform.scale(
              scale: 1.0.h,
              child: Obx(
                () => Checkbox(
                  onChanged: (value) {
                    tiutiuUserController.updateTiutiuUser(
                      TiutiuUserEnum.allowContactViaWhatsApp,
                      value,
                    );
                  },
                  value:
                      tiutiuUserController.tiutiuUser.allowContactViaWhatsApp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _userLastSeen() {
    return Visibility(
      visible: !_itsMe && !isEditiingProfile,
      child: SizedBox(
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
      ),
    );
  }

  Widget _userSinceDate() {
    return Visibility(
      visible: !_itsMe && !isEditiingProfile,
      child: AutoSizeText(
        '${UserStrings.userSince} ${Formatter.getFormattedDate(_user.createdAt ?? DateTime.now().toIso8601String())}',
      ),
    );
  }

  Widget _userPostsQty() {
    return Visibility(
      visible: !_itsMe && !isEditiingProfile,
      child: StreamBuilder<int>(
        initialData: 1,
        stream: profileController.getUserPostsCount(_user.uid),
        builder: (context, snapshot) {
          final qty = snapshot.data ?? 1;
          return AutoSizeText('$qty ${UserStrings.postsQty(qty)}');
        },
      ),
    );
  }

  Widget _contactTitle() {
    return Visibility(
      visible: !_itsMe,
      child: Column(
        children: [
          Divider(),
          AutoSizeText(
            style: TextStyles.fontSize(),
            UserStrings.contact,
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _contactButtonRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: !_itsMe,
            child: Expanded(
              child: ButtonWide(
                color: AppColors.secondary,
                text: AppStrings.chat,
                isToExpand: false,
                icon: Icons.phone,
                action: () {},
              ),
            ),
          ),
          SizedBox(width: 16.0.w),
          Visibility(
            visible: !_itsMe,
            child: Expanded(
              child: ButtonWide(
                text: AppStrings.whatsapp,
                color: AppColors.primary,
                icon: Tiutiu.whatsapp,
                isToExpand: false,
                action: () {
                  Launcher.openWhatsApp(
                    number: Formatter.unmaskNumber(_user.phoneNumber!),
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: _itsMe,
            child: Expanded(
              child: ButtonWide(
                color: AppColors.primary,
                text: AppStrings.save,
                isToExpand: false,
                action: () async {
                  await tiutiuUserController.updateUserDataOnServer();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _itsMe => _user.uid == tiutiuUserController.tiutiuUser.uid;
}
