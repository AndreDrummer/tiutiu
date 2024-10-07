import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/home/widgets/persistent_header_deleagate.dart';
import 'package:tiutiu/features/home/utils/expanded_home_height_size.dart';
import 'package:tiutiu/core/remote_config/model/admin_remote_config.dart';
import 'package:tiutiu/features/home/widgets/closed_for_maintenance.dart';
import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/sponsored/model/sponsored.dart';
import 'package:tiutiu/features/posts/flow/init_post_flow.dart';
import 'package:tiutiu/features/tiutiutok/views/tiutiutok.dart';
import 'package:tiutiu/features/home/widgets/bottom_bar.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/features/posts/views/posts_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/shop/tiutiushop.dart';
import 'package:tiutiu/features/more/views/more.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/widgets/top_bar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TiuTiuPopUp {
  @override
  void initState() {
    runAsyncs();
    super.initState();
  }

  Future<void> _promptRequestToNotification() async {
    showPopUp(
      message: AppLocalizations.of(Get.context!)!.notificationsMessageRequest,
      backGroundColor: AppColors.info,
      confirmText: AppLocalizations.of(Get.context!)!.yes,
      title: AppLocalizations.of(Get.context!)!.notificationsWarning,
      barrierDismissible: false,
      denyText: AppLocalizations.of(Get.context!)!.no,
      mainAction: () {
        Get.back();
      },
      secondaryAction: () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
        Get.back();
      },
    );
  }

  Future<void> handleNotificationsDeniedRequests() async {
    final notificationPermissionStatus = await Permission.notification.status;

    if (notificationPermissionStatus == PermissionStatus.denied) {
      await Permission.notification.request();
    } else if (notificationPermissionStatus == PermissionStatus.permanentlyDenied) {
      await _promptRequestToNotification();
    }
  }

  Future<void> runAsyncs() async {
    Future.delayed(Duration(seconds: 1), () async {
      await adMobController.showOpeningAd();
      await crashlyticsController.init();

      await handleNotificationsDeniedRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () {
          final conditionToShowFloatingButton =
              homeController.bottomBarIndex == BottomBarIndex.DONATE.indx && !systemController.isToCloseApp;

          final screens = <Widget>[
            ClosedForMaintenance(child: DonateList()),
            ClosedForMaintenance(child: TiutiuTok()),
            ClosedForMaintenance(child: InitPostFlow()),
            adminRemoteConfigController.configs.showShopButton
                ? ClosedForMaintenance(child: TiutiuShop())
                : ClosedForMaintenance(child: FinderList()),
            ClosedForMaintenance(child: More()),
          ];

          return Scaffold(
            restorationId: 'scaffold',
            key: UniqueKey(),
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
                            : toolbarHeight(),
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        expandedHeight: expandedHeight(),
                        shadowColor: AppColors.white,
                        flexibleSpace: TopBar(),
                        floating: true,
                        pinned: true,
                      );
                    },
                  ),
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: PersistentHeaderDelegate(),
                  ),
                ];
              },
              body: Stack(
                children: [
                  Positioned.fill(child: screens.elementAt(homeController.bottomBarIndex)),
                  Visibility(
                    visible: homeController.bottomBarIndex == BottomBarIndex.TIUTIUTOK.indx
                        ? postsController.tiutiutokPostsListIsEmpty
                        : true,
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
              padding: EdgeInsets.only(bottom: adminRemoteConfigController.configs.allowGoogleAds ? 88.0.h : 56.0.h),
              child: ChangePostsVisibilityFloatingButtom(
                visibility: conditionToShowFloatingButton && postsController.filteredPosts.isNotEmpty,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
            resizeToAvoidBottomInset: false,
          );
        },
      ),
    );
  }

  double expandedHeight() {
    final AdminRemoteConfig configs = adminRemoteConfigController.configs;
    final List<Sponsored> sponsoreds = sponsoredController.sponsoreds;

    final showingSponsoredAds = configs.showSponsoredAds && sponsoreds.isNotEmpty;
    final isFilteringByName = filterController.filterParams.value.orderBy == AppLocalizations.of(context)!.name;
    final appIsClosed = systemController.isToCloseApp;

    final conditionToAddHeight = !appIsClosed &&
        (homeController.bottomBarIndex == BottomBarIndex.DONATE.indx ||
            (!adminRemoteConfigController.configs.showShopButton &&
                homeController.bottomBarIndex == BottomBarIndex.FINDER.indx));

    if (conditionToAddHeight) {
      final thereIsDeveloperCommunication = adminRemoteConfigController.configs.thereIsAdminCommunication;

      final showInfoBanner = (authController.userExists && !tiutiuUserController.tiutiuUser.emailVerified);

      if ((thereIsDeveloperCommunication || showInfoBanner) && systemController.properties.internetConnected) {
        return expandedHomeHeightWithAdminInfoAndInternetConnection(
          showingSponsoredAds: showingSponsoredAds || isFilteringByName,
        );
      } else if (!systemController.properties.internetConnected) {
        return expandedHomeHeightWithoutInternetConnection(
          showingSponsoredAds: showingSponsoredAds || isFilteringByName,
        );
      } else {
        return expandedHomeHeightDefault(showingSponsoredAds: showingSponsoredAds || isFilteringByName);
      }
    }

    return 0.0.h;
  }

  double toolbarHeight() {
    final posts = postsController.posts;
    final cardVisibilityKind = postsController.cardVisibilityKind;

    if (homeController.bottomBarIndex != BottomBarIndex.DONATE.indx) return 0.0;

    if (cardVisibilityKind == CardVisibilityKind.banner && posts.length < 6) return 56.0;
    if (cardVisibilityKind == CardVisibilityKind.card && posts.length < 3) return 56.0;

    return 0.0;
  }
}
