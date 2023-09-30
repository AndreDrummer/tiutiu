import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreController extends GetxController {
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  void handleOptionHitted(BuildContext context, String option) {
    if (option == AppLocalizations.of(context)!.adoptioinForm) Get.toNamed(Routes.infoAdoptionForm);
    if (option == AppLocalizations.of(context)!.myPosts) postsController.openMypostsLists();
    if (option == AppLocalizations.of(context)!.talkWithUs) Get.toNamed(Routes.talkWithUs);
    if (option == AppLocalizations.of(context)!.partners) Get.toNamed(Routes.partners);
    if (option == AppLocalizations.of(context)!.messages) Get.toNamed(Routes.contacts);
    if (option == AppLocalizations.of(context)!.settings) Get.toNamed(Routes.settings);
    if (option == AppLocalizations.of(context)!.saveds) Get.toNamed(Routes.favorites);
    if (option == AppLocalizations.of(context)!.support) Get.toNamed(Routes.suportUs);
    if (option == AppLocalizations.of(context)!.ourNet) Get.toNamed(Routes.followUs);
    if (option == AppLocalizations.of(context)!.about) Get.toNamed(Routes.about);
  }

  Future<void> save() async {
    _isLoading(true);

    await authController.updateUserInfo();
    tiutiuUserController.checkUserRegistered();

    _isLoading(false);
  }

  List<String> get myProfileOptionsTile {
    final bool enableDonateTile = adminRemoteConfigController.configs.enableDonateTile;
    List<String> list = [..._myProfileOptionsTile];
    if (!enableDonateTile) list.remove(AppLocalizations.of(Get.context!)!.support);
    return list;
  }

  static List<String> _myProfileOptionsTile = [
    AppLocalizations.of(Get.context!)!.talkWithUs,
    AppLocalizations.of(Get.context!)!.ourNet,
    AppLocalizations.of(Get.context!)!.saveds,
    AppLocalizations.of(Get.context!)!.myPosts,
    AppLocalizations.of(Get.context!)!.messages,
    AppLocalizations.of(Get.context!)!.support,
    AppLocalizations.of(Get.context!)!.adoptioinForm,
    AppLocalizations.of(Get.context!)!.settings,
    AppLocalizations.of(Get.context!)!.partners,
    AppLocalizations.of(Get.context!)!.about,
  ];

  List<IconData> get myProfileOptionsIcon {
    final bool enableDonateTile = adminRemoteConfigController.configs.enableDonateTile;
    List<IconData> list = [..._myProfileOptionsIcon];
    if (!enableDonateTile) list.remove(Icons.volunteer_activism_outlined);
    return list;
  }

  final List<IconData> _myProfileOptionsIcon = [
    Icons.headset_mic_outlined,
    Icons.groups_outlined,
    Icons.bookmark_border_rounded,
    Icons.photo_outlined,
    Icons.forum_outlined,
    Icons.volunteer_activism_outlined,
    Icons.list_alt_rounded,
    Icons.manage_accounts_outlined,
    Icons.handshake_outlined,
    Icons.info_outline,
  ];
}
