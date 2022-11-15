import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/features/system/controllers.dart';
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
      case MyProfileOptionsTile.favorites:
        homeController.setFavoriteIndex();
        break;
      case MyProfileOptionsTile.settings:
        isSetting = true;
        break;
      case MyProfileOptionsTile.myPosts:
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
    MyProfileOptionsTile.favorites,
    MyProfileOptionsTile.chat,
    MyProfileOptionsTile.settings,
    MyProfileOptionsTile.about,
    MyProfileOptionsTile.support,
    MyProfileOptionsTile.deleteAccount,
    MyProfileOptionsTile.leave,
  ];

  List<IconData> get myProfileOptionsIcon => _myProfileOptionsIcon;

  final List<IconData> _myProfileOptionsIcon = [
    Icons.grid_view,
    Icons.favorite,
    FontAwesomeIcons.comments,
    FontAwesomeIcons.gear,
    FontAwesomeIcons.info,
    FontAwesomeIcons.circleDollarToSlot,
    FontAwesomeIcons.deleteLeft,
    FontAwesomeIcons.arrowRightFromBracket,
  ];
}
