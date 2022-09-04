import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/home_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiltersKind extends StatelessWidget {
  const FiltersKind({super.key});

  @override
  Widget build(BuildContext context) {
    final filtersKindText = filterController.filterKindText;
    final filtersIcon = filterController.filterKindIcon;

    return Obx(
      () {
        final filterText = filterController.filterKindTextSelected;
        return Container(
          height: 64.0.h,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (int i = 0; i < filtersKindText.length; i++)
              HomeFilterItem(
                onItemTap: () {
                  filterController.filterKindTextSelected = filtersKindText[i];
                },
                isActive: filterText == filtersKindText[i],
                kind: filtersKindText[i],
                icon: filtersIcon[i],
              )
          ]),
        );
      },
    );
  }
}
