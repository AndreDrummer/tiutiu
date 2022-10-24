import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/core/data/states_and_cities.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterResultCount extends StatelessWidget {
  const FilterResultCount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Divider(height: 8.0.h, color: AppColors.secondary),
          Container(
            height: 24.0.h,
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            margin: EdgeInsets.only(bottom: 4.0.h),
            child: Row(
              children: [
                Row(
                  children: [
                    AutoSizeText(
                      '${postsController.petsCount} ',
                      style: TextStyles.fontSize12(),
                    ),
                    AutoSizeText(
                      FilterStrings.foundAt,
                      style: TextStyles.fontSize12(),
                    ),
                  ],
                ),
                Spacer(),
                DropdownButton<String>(
                  value: filterController.filterStateSelected,
                  underline: SizedBox(),
                  onChanged: (value) {
                    filterController.filterStateSelected = value;
                  },
                  items: StatesAndCities()
                      .stateInitials
                      .map(
                        (e) => DropdownMenuItem<String>(
                          child: AutoSizeText(
                            e,
                            style: TextStyles.fontSize12(),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                ),
                Spacer(),
                Row(
                  children: [
                    AutoSizeText(
                      FilterStrings.orderedBy,
                      style: TextStyles.fontSize12(),
                    ),
                    CustomDropdownButtonSearch(
                      itemList: filterController.orderTypeList,
                      initialValue: filterController.orderBy,
                      onChange: (String value) {
                        filterController.orderBy = value;
                      },
                      colorText: Colors.black54,
                      isExpanded: false,
                      withPipe: false,
                      fontSize: 12.sp,
                      label: '',
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 8.0.h, color: AppColors.secondary),
        ],
      ),
    );
  }
}
