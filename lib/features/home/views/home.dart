import 'package:tiutiu/features/auth/views/authenticated_area.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/views/pets_list.dart';
import 'package:tiutiu/features/home/widgets/header.dart';
import 'package:tiutiu/features/profile/views/profile.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/screen/favorites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class Home extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    final _screens = <Widget>[
      DonateList(),
      DisappearedList(),
      AuthenticatedArea(child: Favorites()),
      AuthenticatedArea(child: Profile(user: tiutiuUserController.tiutiuUser)),
      AuthenticatedArea(child: Favorites()),
    ];

    return SafeArea(
      child: Obx(
        () => WillPopScope(
          onWillPop: () async {
            return showPopUp(
              context,
              confirmText: AppStrings.yes,
              barrierDismissible: false,
              title: AppStrings.endApp,
              denyText: AppStrings.no,
              AppStrings.wannaLeave,
              danger: false,
              warning: true,
              mainAction: () {
                Get.back();
              },
              secondaryAction: () {
                exit(0);
              },
            ).then((value) => false);
          },
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    expandedHeight: homeController.bottomBarIndex < 2
                        ? Get.height / 4
                        : 0.0,
                    shadowColor: AppColors.white,
                    flexibleSpace: Header(),
                    toolbarHeight:
                        homeController.bottomBarIndex < 2 ? 56.0.h : 0.0,
                    floating: true,
                    pinned: true,
                  ),
                ];
              },
              body: _screens.elementAt(homeController.bottomBarIndex),
              controller: homeController.scrollController,
              floatHeaderSlivers: true,
            ),
            bottomNavigationBar: Visibility(
              // visible: homeController.showAuthHostersInFullScreen,
              child: BottomBar(),
            ),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }
}
