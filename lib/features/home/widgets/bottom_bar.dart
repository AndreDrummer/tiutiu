import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return BottomNavigationBar(
            onTap: (index) => homeController.setIndex(index),
            currentIndex: homeController.bottomBarIndex,
            selectedItemColor: AppColors.primary,
            backgroundColor: AppColors.black,
            unselectedItemColor: AppColors.white,
            type: BottomNavigationBarType.fixed,
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
            ).toList());
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

  Widget tiuTokIcon(bool isActive) {
    return SizedBox(
      height: 20.0.h,
      width: 20.0.h,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: AssetHandle.getImage(
          isActive ? ImageAssets.playPawGreen : ImageAssets.playPawWhite,
        ),
      ),
    );
  }
}
