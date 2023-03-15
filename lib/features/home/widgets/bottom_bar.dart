import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/tiutiutok_icon.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool isTiuTokIndex = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isToCloseApp = systemController.isToCloseApp;

        return Visibility(
          visible: !isToCloseApp,
          child: BottomNavigationBar(
              onTap: (index) {
                if (index == BottomBarIndex.TIUTIUTOK.indx) {
                  setState(() {
                    isTiuTokIndex = true;
                  });
                } else {
                  setState(() {
                    isTiuTokIndex = false;
                  });
                }
                homeController.setIndex(index);
              },
              selectedLabelStyle: isTiuTokIndex ? GoogleFonts.miltonianTattoo() : null,
              currentIndex: homeController.bottomBarIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.white,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.black,
              showSelectedLabels: true,
              unselectedFontSize: 10.0,
              selectedFontSize: 10,
              items: _bottomBarLabels.map(
                (label) {
                  final index = _bottomBarLabels.indexOf(label);
                  return BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4.0.h),
                      child: Stack(
                        children: [
                          index == 1
                              ? tiuTokIcon(homeController.bottomBarIndex == index)
                              : Icon(
                                  _bottomBarIcons.elementAt(index),
                                  size: 20.0.h,
                                ),
                        ],
                      ),
                    ),
                    label: label,
                  );
                },
              ).toList()),
        );
      },
    );
  }

  final List<String> _bottomBarLabels = [
    AppLocalizations.of(Get.context!).adopte,
    AppLocalizations.of(Get.context!).tiutok,
    AppLocalizations.of(Get.context!).post,
    AppLocalizations.of(Get.context!).store,
    AppLocalizations.of(Get.context!).more,
  ];

  final List<IconData> _bottomBarIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.play,
    FontAwesomeIcons.squarePlus,
    Icons.shopping_bag_outlined,
    Icons.menu,
  ];

  Widget tiuTokIcon(bool isActive) => TiutiutokIcon(color: isActive ? AppColors.primary : AppColors.white);
}
