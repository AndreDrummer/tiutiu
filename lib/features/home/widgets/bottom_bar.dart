import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
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
    AppStrings.pets,
    AppStrings.myAccount,
    BottomBarStrings.myFavorites,
  ];

  final List<IconData> bottomBarIcons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.user,
    FontAwesomeIcons.heart,
  ];
}
