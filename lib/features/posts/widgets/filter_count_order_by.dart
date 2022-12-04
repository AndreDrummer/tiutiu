import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/widgets/custom_input_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterResultCount extends StatelessWidget {
  const FilterResultCount({
    super.key,
    this.isInMyPosts = false,
  });

  final bool isInMyPosts;

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
                    AutoSizeTexts.autoSizeText12('${postsController.postsCount} '),
                    Visibility(
                      visible: !isInMyPosts,
                      child: AutoSizeTexts.autoSizeText12(FilterStrings.foundAt),
                    ),
                    Visibility(
                      visible: isInMyPosts,
                      child: AutoSizeTexts.autoSizeText12(FilterStrings.ads),
                    ),
                  ],
                ),
                Spacer(),
                Visibility(
                  replacement: Row(
                    children: [
                      AutoSizeTexts.autoSizeText12(FilterStrings.disappeared),
                      Obx(
                        () => Switch(
                          value: filterController.filterParams.value.disappeared,
                          onChanged: (_) {
                            filterController.updateParams(
                              FilterParamsEnum.disappeared,
                              !filterController.filterParams.value.disappeared,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  visible: !isInMyPosts,
                  child: DropdownButton<String>(
                    value: filterController.filterParams.value.state,
                    underline: SizedBox(),
                    onChanged: (value) {
                      filterController.updateParams(
                        FilterParamsEnum.state,
                        value,
                      );
                    },
                    items: StatesAndCities()
                        .stateInitials
                        .map(
                          (e) => DropdownMenuItem<String>(
                            child: AutoSizeTexts.autoSizeText12(e),
                            value: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    AutoSizeTexts.autoSizeText12(FilterStrings.orderedBy),
                    CustomDropdownButtonSearch(
                      initialValue: filterController.getParams.orderBy,
                      itemList: filterController.orderTypeList,
                      onChange: (String value) {
                        filterController.updateParams(
                          FilterParamsEnum.orderBy,
                          value,
                        );
                      },
                      colorText: Colors.black54,
                      isExpanded: false,
                      withPipe: false,
                      fontSize: 12,
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
