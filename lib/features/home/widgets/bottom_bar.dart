import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return BottomNavigationBar(
            backgroundColor: AppColors.black,
            onTap: (index) => homeController.setIndex(index),
            currentIndex: homeController.bottomBarIndex,
            selectedItemColor: AppColors.primary,
            unselectedFontSize: 10.0,
            selectedFontSize: 10,
            unselectedItemColor: AppColors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            items: getBottomBarLabelsVerified()
                .map(
                  (label) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4.0.h),
                      child: Icon(
                        getBottomBarIconsVerified().elementAt(
                          getBottomBarLabelsVerified().indexOf(label),
                        ),
                        size: 20.0.h,
                      ),
                    ),
                    label: label,
                  ),
                )
                .toList());
      },
    );
  }

  final List<String> _bottomBarLabels = [
    AppStrings.adopte,
    AppStrings.tiutok,
    AppStrings.post,
    AppStrings.find,
    AppStrings.more,
  ];

  final List<IconData> _bottomBarIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.play,
    FontAwesomeIcons.squarePlus,
    FontAwesomeIcons.searchengin,
    Icons.menu,
  ];

  List<String> getBottomBarLabelsVerified() {
    if (authController.user?.emailVerified ?? false) return _bottomBarLabels;

    // Remove chat option from NavigationBar
    if (_bottomBarLabels.contains(AppStrings.chat)) {
      _bottomBarLabels.remove(AppStrings.chat);
    }
    return _bottomBarLabels;
  }

  List<IconData> getBottomBarIconsVerified() {
    if (authController.user?.emailVerified ?? false) return _bottomBarIcons;

    // Remove chat option from NavigationBar
    if (_bottomBarIcons.contains(Icons.forum)) {
      _bottomBarIcons.remove(Icons.forum);
    }
    return _bottomBarIcons;
  }
}
