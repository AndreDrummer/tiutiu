import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/features/home/views/pets.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/my_account.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class Home extends StatelessWidget with TiuTiuPopUp {
  final _screens = <Widget>[
    Pets(),
    Pets(disappeared: true),
    homeController.isAuthenticated ? MyAccount() : AuthScreen(),
    homeController.isAuthenticated ? Favorites() : AuthScreen(),
    homeController.isAuthenticated ? Favorites() : AuthScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => WillPopScope(
          onWillPop: () async {
            return showPopUp(
              context,
              AppStrings.wannaLeave,
              barrierDismissible: false,
              confirmText: AppStrings.yes,
              denyText: AppStrings.no,
              danger: false,
              warning: true,
              mainAction: () {
                Get.back();
              },
              secondaryAction: () {
                exit(0);
              },
              title: AppStrings.endApp,
            ).then((value) => false);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                _screens.elementAt(homeController.bottomBarIndex),
              ],
            ),
            bottomNavigationBar: BottomBar(),
          ),
        ),
      ),
    );
  }
}
