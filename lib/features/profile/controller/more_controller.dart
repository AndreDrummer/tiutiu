import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreController extends GetxController {
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  void handleOptionHitted(String option) {
    switch (option) {
      case MyProfileOptionsTile.myPosts:
        postsController.openMypostsLists();
        break;
      case MyProfileOptionsTile.favorites:
        Get.toNamed(Routes.favorites);
        break;
      case MyProfileOptionsTile.settings:
        Get.toNamed(Routes.settings);
        break;
      case MyProfileOptionsTile.about:
        break;
      case MyProfileOptionsTile.talkWithUs:
        Get.toNamed(Routes.talkWithUs);
        break;
      case MyProfileOptionsTile.support:
        Get.toNamed(Routes.suportUs);
        break;
      case MyProfileOptionsTile.ourNet:
        Get.toNamed(Routes.followUs);
        break;
      case MyProfileOptionsTile.deleteAccount:
        Get.toNamed(Routes.deleteAccount);
        break;
      case MyProfileOptionsTile.leave:
        authController.signOut();
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
    MyProfileOptionsTile.favorites,
    MyProfileOptionsTile.settings,
    MyProfileOptionsTile.about,
    MyProfileOptionsTile.talkWithUs,
    MyProfileOptionsTile.ourNet,
    MyProfileOptionsTile.support,
    MyProfileOptionsTile.deleteAccount,
    MyProfileOptionsTile.leave,
  ];

  List<IconData> get myProfileOptionsIcon => _myProfileOptionsIcon;

  final List<IconData> _myProfileOptionsIcon = [
    Icons.view_agenda,
    Icons.favorite,
    Icons.manage_accounts,
    Icons.info,
    Icons.headset_mic,
    Icons.groups,
    Icons.volunteer_activism,
    Icons.person_off,
    Icons.exit_to_app,
  ];
}
