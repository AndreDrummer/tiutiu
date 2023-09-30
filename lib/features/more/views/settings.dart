import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/custom_list_tile.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
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
        appBar: DefaultBasicAppBar(text: AppLocalizations.of(context)!.settings),
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
                      text: AppLocalizations.of(context)!.editProfile,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: FontAwesomeIcons.earthAmericas,
                      text: AppLocalizations.of(context)!.setMyProfileAsONG,
                      badgeText: AppLocalizations.of(context)!.commingSoon,
                      onTap: () {},
                      showBadge: true,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: Icons.map,
                      onTap: () {
                        Get.toNamed(Routes.changeCountry);
                      },
                      text: AppLocalizations.of(context)!.changeCountry,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: Icons.person_off,
                      onTap: () {
                        _deleteAccount();
                      },
                      text: AppLocalizations.of(context)!.deleteAccount,
                    ),
                    Divider(),
                    CustomListTile(
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      onTap: () {
                        _exitApp();
                      },
                      text: AppLocalizations.of(context)!.leave,
                    ),
                  ],
                ),
              ),
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
      message: AppLocalizations.of(context)!.wannaLeave,
      confirmText: AppLocalizations.of(context)!.yes,
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
      title: AppLocalizations.of(context)!.leave,
      denyText: AppLocalizations.of(context)!.no,
    );
  }
}
