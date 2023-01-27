import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/custom_list_tile.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(text: MyProfileOptionsTile.settings),
        body: Card(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 6.0.h),
                    CustomListTile(
                      icon: FontAwesomeIcons.penToSquare,
                      onTap: () {
                        Get.toNamed(Routes.editProfile);
                      },
                      text: SettingsStrings.editProfile,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: FontAwesomeIcons.earthAmericas,
                      text: SettingsStrings.setMyProfileAsONG,
                      badgeText: AppStrings.commingSoon,
                      onTap: () {},
                      showBadge: true,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: Icons.person_off,
                      onTap: () {
                        _deleteAccount();
                      },
                      text: MyProfileOptionsTile.deleteAccount,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      onTap: () {
                        _exitApp();
                      },
                      text: MyProfileOptionsTile.leave,
                    ),
                  ],
                ),
              ),
              Spacer(),
              AdBanner(
                adId: systemController.getAdMobBlockID(
                  blockName: AdMobBlockName.homeFooterAdBlockId,
                  type: AdMobType.banner,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final canDeleteAccount = await deleteAccountController.canDeleteAccount();

    if (!canDeleteAccount)
      await deleteAccountController.showDeleteAccountLogoutWarningPopup();
    else
      Get.toNamed(Routes.deleteAccount);
  }

  Future<void> _exitApp() async {
    await showPopUp(
      message: AppStrings.wannaLeave,
      confirmText: AppStrings.yes,
      textColor: AppColors.black,
      mainAction: () {
        Get.back();
      },
      secondaryAction: () {
        Get.back();
        authController.signOut().then((value) => Get.offAllNamed(Routes.startScreen));
      },
      backGroundColor: AppColors.warning,
      barrierDismissible: false,
      title: AppStrings.leave,
      denyText: AppStrings.no,
    );
  }
}
