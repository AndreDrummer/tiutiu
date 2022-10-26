import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/models/filter_params.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/home_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiltersType extends StatelessWidget {
  const FiltersType({super.key});

  @override
  Widget build(BuildContext context) {
    final filtersTypeText = filterController.filterTypeText;
    final filtersIcon = filterController.filterTypeIcon;

    return Obx(
      () {
        final filterText = filterController.getParams.type;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2.0.w),
          height: Get.width / 5,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            for (int i = 0; i < filtersTypeText.length; i++)
              HomeFilterItem(
                onItemTap: () {
                  filterController.updateParams(
                    FilterParamsEnum.type,
                    filtersTypeText[i],
                  );
                },
                isActive: filterText == filtersTypeText[i],
                type: filtersTypeText[i],
                icon: filtersIcon[i],
              )
          ]),
        );
      },
    );
  }
}
