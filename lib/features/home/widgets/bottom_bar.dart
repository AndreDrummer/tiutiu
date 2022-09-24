import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
          onTap: (index) => homeController.bottomBarIndex = index,
          currentIndex: homeController.bottomBarIndex,
          unselectedItemColor: AppColors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.white,
          backgroundColor: Colors.black,
          showSelectedLabels: true,
          items: bottomBarLabels
              .map(
                (label) => BottomNavigationBarItem(
                  icon: Icon(
                    bottomBarIcons.elementAt(
                      bottomBarLabels.indexOf(label),
                    ),
                  ),
                  label: label,
                ),
              )
              .toList()),
    );
  }

  final List<String> bottomBarLabels = [
    AppStrings.adopte,
    AppStrings.disappeareds,
    AppStrings.post,
    AppStrings.profile,
    BottomBarStrings.favorites,
  ];

  final List<IconData> bottomBarIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.question,
    FontAwesomeIcons.squarePlus,
    FontAwesomeIcons.user,
    FontAwesomeIcons.heart,
  ];
}
