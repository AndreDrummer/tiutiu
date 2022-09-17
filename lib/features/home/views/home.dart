import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/views/pets_list.dart';
import 'package:tiutiu/features/home/widgets/header.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/screen/auth_screen.dart';
import 'package:tiutiu/screen/my_account.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class Home extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    final _screens = <Widget>[
      PetsList(),
      PetsList(),
      homeController.isAuthenticated ? MyAccount() : AuthScreen(),
      homeController.isAuthenticated ? Favorites() : AuthScreen(),
      homeController.isAuthenticated ? Favorites() : AuthScreen(),
    ];

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
            body: NestedScrollView(
              controller: homeController.scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    expandedHeight: Get.height / 4,
                    flexibleSpace: Header(),
                    toolbarHeight: 56.0.h,
                    floating: true,
                    pinned: true,
                  ),
                ];
              },
              body: _screens.elementAt(homeController.bottomBarIndex),
              floatHeaderSlivers: true,
            ),
            bottomNavigationBar: BottomBar(),
          ),
        ),
      ),
    );
  }
}
