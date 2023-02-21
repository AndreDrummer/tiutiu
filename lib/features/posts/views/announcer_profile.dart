import 'package:tiutiu/features/dennounce/views/user_dennounce_screen.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/contact_type.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncerProfile extends StatelessWidget with TiuTiuPopUp {
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
        body: Container(
          alignment: Alignment.center,
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
              _userLastSeen(context),
              _userSinceDate(context),
              Spacer(),
              _userPostsQty(),
              Spacer(),
              _contactTitle(context),
              _contactButtonRow(context),
              Spacer(),
              TextButton.icon(
                label: AutoSizeTexts.autoSizeText14(AppLocalizations.of(context).dennounceUser(
                  _user.displayName ?? '',
                )),
                icon: Icon(Icons.warning_amber),
                onPressed: () {
                  userDennounceController.updateUserDennounce(UserDennounceEnum.dennouncedUser, _user);

                  showsDennouncePopup(content: UserDennounceScreen());
                },
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
          radius: Get.width / 4,
          onAssetRemoved: () {},
          viewOnly: true,
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
    return AutoSizeTexts.autoSizeText16(
      '${_user.displayName}',
      fontWeight: FontWeight.w700,
    );
  }

  Widget _userLastSeen(BuildContext context) {
    return SizedBox(
      height: 32.0.h,
      child: Column(
        children: [
          AutoSizeTexts.autoSizeText12(
            '${AppLocalizations.of(context).userLastSeen} ${Formatters.getFormattedDateAndTime(_user.lastLogin ?? DateTime.now().toIso8601String())}',
            fontStyle: FontStyle.italic,
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _userSinceDate(BuildContext context) {
    final DateTime dateTime = DateTime.parse(_user.createdAt ?? DateTime.now().toIso8601String());

    return AutoSizeText(
      '${AppLocalizations.of(context).userSince} ${Formatters.formmatedExtendedDate(dateTime: dateTime).split(',').last.trim()}',
    );
  }

  Widget _userPostsQty() {
    return StreamBuilder<int>(
      initialData: 1,
      stream: tiutiuUserController.getUserPostsById(_user.uid!).asyncMap<int>((event) => event.docs.length),
      builder: (context, snapshot) {
        final qty = snapshot.data ?? 1;
        return AutoSizeText('$qty ${AppLocalizations.of(context).postsQty(qty)}');
      },
    );
  }

  Widget _contactTitle(BuildContext context) {
    return Column(
      children: [
        Divider(),
        AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).contact),
        Divider(),
      ],
    );
  }

  Widget _contactButtonRow(BuildContext context) {
    return WarningBanner(
      isHiddingContactInfo: true,
      fontSize: 10,
      margin: EdgeInsets.only(left: 2.0.w, right: 16.0.w, top: 24.0.h),
      padding: EdgeInsets.all(4.0.h),
      replacement: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ButtonWide(
              fontSize: 12,
              color: AppColors.secondary,
              text: AppLocalizations.of(context).chatWithAnnouncer,
              isToExpand: false,
              onPressed: () {
                chatController.handleContactTapped(
                  contactType: ContactType.chat,
                  openDesiredChat: () async {
                    chatController.startsChatWith(
                      myUserId: tiutiuUserController.tiutiuUser.uid!,
                      user: postsController.post.owner!,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: ButtonWide(
              fontSize: 12,
              text: AppLocalizations.of(context).callInWhatsapp,
              color: AppColors.primary,
              isToExpand: false,
              onPressed: () {
                chatController.handleContactTapped(
                  contactType: ContactType.whatsapp,
                  openDesiredChat: () async {
                    await Launcher.openWhatsApp(
                      countryCode: postsController.post.owner!.countryCode ?? '+55',
                      number: postsController.post.owner!.phoneNumber!,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(width: 8.0.w)
        ],
      ),
    );
  }
}
