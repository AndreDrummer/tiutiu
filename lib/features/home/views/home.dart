import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/home/widgets/header.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/features/home/views/screens.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class Home extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
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
                  Obx(
                    () => SliverAppBar(
                      expandedHeight: homeController.bottomBarIndex < 2
                          ? (tiutiuUserController.tiutiuUser.emailVerified
                              ? Get.height / 4.2
                              : Dimensions.getDimensByPlatform(
                                  androidDimen: Get.height / 3.6,
                                  iosDimen: Get.height / 3.75,
                                ))
                          : 0.0,
                      toolbarHeight: homeController.bottomBarIndex < 2 ? 56.0.h : 0.0,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      shadowColor: AppColors.white,
                      flexibleSpace: Header(),
                      floating: true,
                      pinned: true,
                    ),
                  ),
                ];
              },
              body: screens.elementAt(homeController.bottomBarIndex),
              controller: homeController.scrollController,
              floatHeaderSlivers: true,
            ),
            bottomNavigationBar: Visibility(
              child: BottomBar(),
            ),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }
}
