import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/migration/service/migration_service.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
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

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TiuTiuPopUp {
  @override
  void initState() {
    MigrationService().migrate();
    adMobController.showOpeningAd();
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
            bool willClose = false;

            return showPopUp(
              backGroundColor: AppColors.warning,
              message: AppStrings.wannaLeave,
              confirmText: AppStrings.yes,
              textColor: AppColors.black,
              barrierDismissible: false,
              title: AppStrings.endApp,
              denyText: AppStrings.no,
              mainAction: () {
                Get.back();
              },
              secondaryAction: () {
                willClose = true;
                Get.back();
              },
            ).then((_) => willClose);
          },
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  Obx(
                    () {
                      return SliverAppBar(
                        toolbarHeight: homeController.bottomBarIndex < 2
                            ? systemController.properties.internetConnected
                                ? 48.0.h
                                : Dimensions.getDimensBasedOnDeviceHeight(
                                    smaller: 92.0.h,
                                    medium: 84.0.h,
                                    bigger: 76.0.h,
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
              body: Stack(
                children: [
                  Positioned.fill(child: screens.elementAt(homeController.bottomBarIndex)),
                  Positioned(
                    child: AdBanner(
                      adId: systemController.getAdMobBlockID(
                        blockName: AdMobBlockName.homeFooterAdBlockId,
                        type: AdMobType.banner,
                      ),
                    ),
                    bottom: 0,
                    right: 0,
                    left: 0,
                  ),
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
    final showingSponsoredAds = adminRemoteConfigController.configs.showSponsoredAds;

    final homeListPadding = Dimensions.getDimensBasedOnDeviceHeight(
      xSmaller: showingSponsoredAds ? Get.height / 2.5 : Get.height / 3.5,
      smaller: showingSponsoredAds ? Get.height / 2.6 : Get.height / 3.5,
      medium: showingSponsoredAds ? Get.height / 2.8 : Get.height / 4.4,
      bigger: showingSponsoredAds ? Get.height / 2.9 : Get.height / 4.5,
    );

    if (homeController.bottomBarIndex < 2) {
      final thereIsDeveloperCommunication = adminRemoteConfigController.configs.thereIsAdminCommunication;

      final showInfoBanner = !systemController.properties.internetConnected ||
          (authController.userExists && !tiutiuUserController.tiutiuUser.emailVerified);

      if (thereIsDeveloperCommunication || showInfoBanner) {
        return Dimensions.getDimensBasedOnDeviceHeight(
          xSmaller: showingSponsoredAds ? Get.height / 2.45 : Get.height / 3.0,
          smaller: showingSponsoredAds ? Get.height / 2.55 : Get.height / 3.0,
          medium: showingSponsoredAds ? Get.height / 2.70 : Get.height / 3.6,
          bigger: showingSponsoredAds ? Get.height / 2.85 : Get.height / 3.7,
        );
      } else if (showingSponsoredAds && !thereIsDeveloperCommunication) {
        return Dimensions.getDimensBasedOnDeviceHeight(
          xSmaller: Get.height / 2.85,
          smaller: Get.height / 2.95,
          medium: Get.height / 3.10,
          bigger: Get.height / 3.25,
        );
      } else {
        return homeListPadding;
      }
    }

    return 0.0.h;
  }
}
