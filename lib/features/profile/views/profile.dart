import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/load_dark_screen.dart';
import 'package:tiutiu/Widgets/underline_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/Widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
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
    this.isEditingProfile = false,
    this.itsMe = false,
  }) : assert(
          _assertValues(
            isCompletingProfile: isCompletingProfile,
            isEditingProfile: isEditingProfile,
            itsMe: itsMe,
          ),
        );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TiutiuUser _user = profileController.profileUser;
  final bool isCompletingProfile;
  final bool isEditingProfile;
  final bool itsMe;

  static bool _assertValues({
    required bool isCompletingProfile,
    required bool isEditingProfile,
    required bool itsMe,
  }) {
    if (isCompletingProfile || isEditingProfile) {
      return itsMe;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final title = isEditingProfile
        ? MyProfileStrings.editProfile
        : isCompletingProfile
            ? MyProfileStrings.completeProfile
            : _user.displayName ?? '';

    final cardSize = itsMe ? Get.height / 1.65 : Get.height / 1.4;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          profileController.profileUser = tiutiuUserController.tiutiuUser;
          return true;
        },
        child: Scaffold(
          appBar: DefaultBasicAppBar(
            automaticallyImplyLeading: !_itsMe,
            text: title,
          ),
          body: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(8.0),
            height: cardSize,
            child: Stack(
              children: [
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0.h),
                  ),
                  child: _cardContent(context),
                ),
                _loadingWidget()
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
              _userPhoneNumber(),
              Spacer(),
              _userPostsQty(),
              Spacer(),
              _contactTitle(),
              _contactButtonRow(),
              _submitButton(context),
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
        if (!_itsMe) fullscreenController.openFullScreenMode([_user.avatar]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0.h),
        alignment: Alignment.center,
        child: Obx(
          () => AvatarProfile(
            onAssetPicked: (file) {
              profileController.updateUserProfileData(
                TiutiuUserEnum.avatar,
                file,
              );
            },
            avatarPath: profileController.profileUser.avatar,
            radius: _itsMe ? Get.width / 6 : Get.width / 4,
            onAssetRemoved: () {
              profileController.updateUserProfileData(
                TiutiuUserEnum.avatar,
                null,
              );
            },
            viewOnly: !_itsMe,
          ),
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
    return _itsMe
        ? Form(
            key: _formKey,
            child: UnderlineInputText(
              onChanged: (name) {
                profileController.updateUserProfileData(
                  TiutiuUserEnum.displayName,
                  name,
                );
              },
              labelText: _itsMe ? MyProfileStrings.howCallYou : '',
              validator: Validators.verifyEmpty,
              initialValue: _user.displayName,
              fontSizeLabelText: 16.0.h,
              readOnly: !_itsMe,
            ),
          )
        : AutoSizeText(
            '${_user.displayName}',
            style: TextStyles.fontSize16(
              fontWeight: FontWeight.w700,
            ),
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
              profileController.updateUserProfileData(
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

  Widget _userLastSeen() {
    return Visibility(
      visible: !_itsMe && !isEditingProfile,
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
      visible: !_itsMe && !isEditingProfile,
      child: AutoSizeText(
        '${UserStrings.userSince} ${Formatter.getFormattedDate(_user.createdAt ?? DateTime.now().toIso8601String())}',
      ),
    );
  }

  Widget _userPostsQty() {
    return Visibility(
      visible: !_itsMe && !isEditingProfile,
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
      visible: !_itsMe && !isEditingProfile,
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
    return Visibility(
      replacement: SizedBox.shrink(),
      visible: !_itsMe,
      child: Padding(
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
                action: () {},
              ),
            ),
            SizedBox(width: 16.0.w),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Visibility(
      visible: _itsMe,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: ButtonWide(
          color: AppColors.primary,
          text: AppStrings.save,
          isToExpand: false,
          action: () async {
            if (_formKey.currentState!.validate() &&
                profileController.profileUser.avatar != null) {
              profileController.showErrorEmptyPic = false;
              FocusScope.of(context).unfocus();
              profileController.save();
            } else {
              profileController.showErrorEmptyPic = true;
            }
          },
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Obx(
      () => LoadDarkScreen(
        visible: profileController.isLoading && _itsMe,
        message: MyProfileStrings.updatingProfile,
        roundeCorners: true,
      ),
    );
  }

  bool get _itsMe =>
      itsMe || (_user.uid == tiutiuUserController.tiutiuUser.uid);
}
