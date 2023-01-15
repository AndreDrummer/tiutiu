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
        final isCardVisibility = homeController.cardVisibilityKind == CardVisibilityKind.card;

        return BottomNavigationBar(
            backgroundColor: isCardVisibility ? AppColors.black.withOpacity(.2) : AppColors.black,
            onTap: (index) => homeController.setIndex(index),
            currentIndex: homeController.bottomBarIndex,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            items: getBottomBarLabelsVerified()
                .map(
                  (label) => BottomNavigationBarItem(
                    icon: Icon(
                      getBottomBarIconsVerified().elementAt(
                        getBottomBarLabelsVerified().indexOf(label),
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
    AppStrings.find,
    AppStrings.post,
    AppStrings.chat,
    AppStrings.more,
  ];

  final List<IconData> _bottomBarIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.searchengin,
    FontAwesomeIcons.squarePlus,
    Icons.forum,
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
