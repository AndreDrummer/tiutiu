import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/home/widgets/header.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'dart:io';

import 'package:tiutiu/features/profile/views/more.dart';

class Home extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DonateList(),
      FinderList(),
      InitPostFlow(),
      authController.user?.emailVerified ?? false ? MyContacts() : More(),
      More(),
    ];

    return SafeArea(
      child: Obx(
        () => WillPopScope(
          onWillPop: () async {
            return showPopUp(
              message: AppStrings.wannaLeave,
              confirmText: AppStrings.yes,
              barrierDismissible: false,
              title: AppStrings.endApp,
              denyText: AppStrings.no,
              error: false,
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
                  Obx(
                    () {
                      return SliverAppBar(
                        toolbarHeight: homeController.bottomBarIndex < 2
                            ? Dimensions.getDimensBasedOnDeviceHeight(
                                smaller: appController.properties.internetConnected ? 56.0.h : 80.0.h,
                                medium: appController.properties.internetConnected ? 48.0.h : 80.0.h,
                                bigger: appController.properties.internetConnected ? 40.0.h : 64.0.h,
                              )
                            : 0.0,
                        backgroundColor: Colors.transparent,
                        expandedHeight: expandedHeight(),
                        automaticallyImplyLeading: false,
                        shadowColor: AppColors.white,
                        flexibleSpace: Header(),
                        floating: true,
                        pinned: true,
                      );
                    },
                  ),
                ];
              },
              body: screens.elementAt(homeController.bottomBarIndex),
              controller: homeController.scrollController,
              floatHeaderSlivers: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Visibility(
              visible: homeController.bottomBarIndex < 2 && appController.properties.allowPost,
              child: FloatingActionButton(
                child: Icon(
                  homeController.cardVisibilityKind == CardVisibilityKind.card
                      ? Icons.view_list_outlined
                      : Icons.view_agenda,
                ),
                tooltip: AppStrings.changeListVisual,
                onPressed: () {
                  homeController.changeCardVisibilityKind();
                },
              ),
            ),
            bottomNavigationBar: BottomBar(),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }

  double expandedHeight() {
    final homeListPadding = Dimensions.getDimensBasedOnDeviceHeight(
      smaller: Get.height / 3.8,
      medium: Get.height / 4.0,
      bigger: Get.height / 4.7,
    );

    if (homeController.bottomBarIndex < 2) {
      if (!tiutiuUserController.tiutiuUser.emailVerified) {
        return Dimensions.getDimensBasedOnDeviceHeight(
          smaller: Get.height / 3.5,
          medium: Get.height / 3.5,
          bigger: Get.height / 4.0,
        );
      } else {
        return homeListPadding;
      }
    }

    return 0.0.h;
  }
}
