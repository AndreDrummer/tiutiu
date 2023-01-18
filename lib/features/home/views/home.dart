import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/home/utils/expanded_home_height_size.dart';
import 'package:tiutiu/core/remote_config/model/admin_remote_config.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/core/migration/service/migration_service.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/tiutiutok/views/tiutiutok.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/home/widgets/header.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/more/views/more.dart';
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
    MigrationService().migrate();
    showAdAndRequestToTrack();

    super.initState();
  }

  Future<void> showAdAndRequestToTrack() async {
    await adMobController.showOpeningAd();
    await crashlyticsController.init();
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DonateList(),
      TiutiuTok(),
      InitPostFlow(),
      FinderList(),
      More(),
    ];

    return SafeArea(
      child: Obx(
        () {
          final conditionToShowFloatingButton = homeController.bottomBarIndex == BottomBarIndex.DONATE.indx ||
              homeController.bottomBarIndex == BottomBarIndex.FINDER.indx;

          return WillPopScope(
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
                  if (Platform.isIOS) {
                    willClose = true;
                  } else {
                    MoveToBackground.moveTaskToBack();
                  }
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
                          toolbarHeight: conditionToShowFloatingButton && !systemController.properties.internetConnected
                              ? Dimensions.getDimensBasedOnDeviceHeight(
                                  smaller: 92.0.h,
                                  medium: 84.0.h,
                                  bigger: 76.0.h,
                                )
                              : 0.0,
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          expandedHeight: expandedHeight(),
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
                    Visibility(
                      visible: homeController.bottomBarIndex != BottomBarIndex.TIUTIUTOK.indx,
                      child: Positioned(
                        child: AdBanner(
                          adId: systemController.getAdMobBlockID(
                            blockName: AdMobBlockName.homeFooterAdBlockId,
                            type: AdMobType.banner,
                          ),
                        ),
                        bottom: 56,
                        right: 0,
                        left: 0,
                      ),
                    ),
                    Positioned(
                      child: BottomBar(),
                      bottom: 0,
                      right: 0,
                      left: 0,
                    ),
                  ],
                ),
                controller: homeController.scrollController,
                floatHeaderSlivers: true,
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(bottom: 88.0.h),
                child: ChangePostsVisibilityFloatingButtom(
                  visibility: conditionToShowFloatingButton && postsController.filteredPosts.isNotEmpty,
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
              resizeToAvoidBottomInset: false,
            ),
          );
        },
      ),
    );
  }

  double expandedHeight() {
    final AdminRemoteConfig configs = adminRemoteConfigController.configs;
    final List<Sponsored> sponsoreds = sponsoredController.sponsoreds;

    final showingSponsoredAds = configs.showSponsoredAds && sponsoreds.isNotEmpty;

    final conditionToAddHeight = homeController.bottomBarIndex == BottomBarIndex.DONATE.indx ||
        homeController.bottomBarIndex == BottomBarIndex.FINDER.indx;

    if (conditionToAddHeight) {
      final thereIsDeveloperCommunication = adminRemoteConfigController.configs.thereIsAdminCommunication;

      final showInfoBanner = !systemController.properties.internetConnected ||
          (authController.userExists && !tiutiuUserController.tiutiuUser.emailVerified);

      if (thereIsDeveloperCommunication && systemController.properties.internetConnected) {
        return expandedHomeHeightWithAdminInfoAndInternetConnection(showingSponsoredAds: showingSponsoredAds);
      } else if (showInfoBanner) {
        return expandedHomeHeightWithoutInternetConnection(showingSponsoredAds: showingSponsoredAds);
      } else {
        return expandedHomeHeightDefault(showingSponsoredAds: showingSponsoredAds);
      }
    }

    return 0.0.h;
  }
}
