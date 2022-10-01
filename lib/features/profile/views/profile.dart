import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/launcher_functions.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/image_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:tiutiu/core/Custom/icons.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  Profile({TiutiuUser? user}) : _user = user ?? tiutiuUserController.tiutiuUser;

  final TiutiuUser _user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(text: _user.displayName ?? ''),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: Get.height / 1.4,
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
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000.0.h),
        ),
        child: ClipOval(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: AssetHandle.getImage(
              _user.avatar,
              fit: BoxFit.cover,
            ),
            radius: 104.0.h,
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
    return Obx(
      () => TextFormField(
        initialValue: _itsMe
            ? tiutiuUserController.tiutiuUser.displayName
            : _user.displayName,
        style: TextStyles.fontSize22(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          focusedBorder: _itsMe ? null : _noneBorder(),
          enabledBorder: _itsMe ? null : _noneBorder(),
          errorBorder: _itsMe ? null : _noneBorder(),
          border: _itsMe ? null : _noneBorder(),
        ),
        onChanged: (value) {
          tiutiuUserController.updateTiutiuUser(
            TiutiuUserEnum.displayName,
            value,
          );
        },
        readOnly: !_itsMe,
      ),
    );
  }

  Widget _userPhoneNumber() {
    return Visibility(
      visible: _itsMe,
      child: Obx(
        () => TextFormField(
          initialValue: tiutiuUserController.tiutiuUser.phoneNumber,
          style: TextStyles.fontSize22(),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            focusedBorder: _itsMe ? null : _noneBorder(),
            enabledBorder: _itsMe ? null : _noneBorder(),
            errorBorder: _itsMe ? null : _noneBorder(),
            border: _itsMe ? null : _noneBorder(),
          ),
          onChanged: (value) {
            tiutiuUserController.updateTiutiuUser(
              TiutiuUserEnum.phoneNumber,
              value,
            );
          },
          readOnly: !_itsMe,
        ),
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

  OutlineInputBorder _noneBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
    );
  }

  Widget _userLastSeen() {
    return Visibility(
      visible: !_itsMe,
      child: SizedBox(
        height: 32.0.h,
        child: Column(
          children: [
            AutoSizeText(
              '${UserStrings.userLastSeen} ${Formatter.getFormattedDateAndTime(_user.lastLogin!)}',
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
      visible: !_itsMe,
      child: AutoSizeText(
          '${UserStrings.userSince} ${Formatter.getFormattedDate(_user.createdAt!)}'),
    );
  }

  Widget _userPostsQty() {
    return Visibility(
      visible: !_itsMe,
      child: StreamBuilder<int>(
        initialData: 1,
        stream: profileController.getUserPostsCount(_user.uid!),
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
                  print(_user.phoneNumber);
                  print(Formatter.unmaskNumber(_user.phoneNumber!));
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
                action: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _itsMe => _user.uid == tiutiuUserController.tiutiuUser.uid;
}
