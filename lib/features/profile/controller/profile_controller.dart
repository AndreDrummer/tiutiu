import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxBool _isSetting = false.obs;
  final RxBool _isLoading = false.obs;

  bool get isSetting => _isSetting.value;
  bool get isLoading => _isLoading.value;
  void set isSetting(bool value) => _isSetting(value);

  void handleOptionHitted(String option) {
    isSetting = false;

    switch (option) {
      case MyProfileOptionsTile.myPosts:
        postsController.openMypostsLists();
        break;
      case MyProfileOptionsTile.settings:
        isSetting = true;
        break;
      case MyProfileOptionsTile.about:
        break;
      case MyProfileOptionsTile.talkWithUs:
        Get.toNamed(Routes.talkWithUs);
        break;
      case MyProfileOptionsTile.deleteAccount:
        Get.toNamed(Routes.deleteAccount);
        break;
      case MyProfileOptionsTile.leave:
        authController.signOut();
        break;
      case MyProfileOptionsTile.chat:
        Get.toNamed(Routes.contacts);
        break;
    }
  }

  Future<void> save() async {
    _isLoading(true);

    await authController.updateUserInfo();

    _isLoading(false);
  }

  List<String> myProfileOptionsTile = _myProfileOptionsTile;

  static const List<String> _myProfileOptionsTile = [
    MyProfileOptionsTile.myPosts,
    MyProfileOptionsTile.chat,
    MyProfileOptionsTile.settings,
    MyProfileOptionsTile.about,
    MyProfileOptionsTile.talkWithUs,
    MyProfileOptionsTile.support,
    MyProfileOptionsTile.deleteAccount,
    MyProfileOptionsTile.leave,
  ];

  List<IconData> get myProfileOptionsIcon => _myProfileOptionsIcon;

  final List<IconData> _myProfileOptionsIcon = [
    Icons.view_agenda,
    Icons.forum,
    Icons.manage_accounts,
    Icons.info,
    Icons.headset_mic,
    Icons.volunteer_activism,
    Icons.person_off,
    Icons.exit_to_app,
  ];
}
