import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner_300x60.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'package:tiutiu/features/chat/views/my_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/home/widgets/header.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/profile/views/more.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TiuTiuPopUp {
  @override
  void initState() {
    adMobController.showInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DonateList(),
      FinderList(),
      InitPostFlow(),
      Obx(() => tiutiuUserController.tiutiuUser.emailVerified ? MyContacts() : More()),
      More(),
    ];

    return SafeArea(
      child: Obx(
        () => WillPopScope(
          onWillPop: () async {
            return showPopUp(
              backGroundColor: AppColors.warning,
              message: AppStrings.wannaLeave,
              confirmText: AppStrings.yes,
              barrierDismissible: false,
              title: AppStrings.endApp,
              denyText: AppStrings.no,
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
                            ? appController.properties.internetConnected
                                ? 40.0.h
                                : 72.0.h
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
              body: Stack(
                children: [
                  Positioned.fill(
                    child: screens.elementAt(homeController.bottomBarIndex),
                  ),
                  Obx(() {
                    bool showAd = false;

                    showAd = authController.userExists && homeController.bottomBarIndex != 2 ||
                        !authController.userExists && homeController.bottomBarIndex < 2;

                    return Visibility(
                      visible: showAd,
                      child: Positioned(
                        child: AdBanner300x60(adBlockName: AdMobBlockName.home),
                        bottom: 0.0.h,
                      ),
                    );
                  })
                ],
              ),
              controller: homeController.scrollController,
              floatHeaderSlivers: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Visibility(
              visible: homeController.bottomBarIndex < 2,
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
      smaller: Get.height / 4.5,
      medium: Get.height / 4.5,
      bigger: Get.height / 4.8,
    );

    if (homeController.bottomBarIndex < 2) {
      if (!tiutiuUserController.tiutiuUser.emailVerified) {
        return Dimensions.getDimensBasedOnDeviceHeight(
          smaller: Get.height / 3.7,
          medium: Get.height / 4.5,
          bigger: Get.height / 4.5,
        );
      } else {
        return homeListPadding;
      }
    }

    return 0.0.h;
  }
}
