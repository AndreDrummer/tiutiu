import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/core/widgets/custom_input_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/system/model/system.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterResultCount extends StatelessWidget {
  const FilterResultCount({
    required this.postsCount,
    this.isInMyPosts = false,
    super.key,
  });

  final bool isInMyPosts;
  final int postsCount;

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
                    AutoSizeTexts.autoSizeText12('$postsCount '),
                    Visibility(
                      child: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).foundAt),
                      visible: !isInMyPosts,
                    ),
                    Visibility(
                      child: AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).posts),
                      visible: isInMyPosts,
                    ),
                  ],
                ),
                Spacer(),
                Visibility(
                  replacement: Row(
                    children: [
                      AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).disappeared),
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
                  child: _brazilOrOtherCountriesFilter(),
                  visible: !isInMyPosts,
                ),
                Spacer(),
                Row(
                  children: [
                    AutoSizeTexts.autoSizeText12(AppLocalizations.of(context).orderedBy),
                    CustomDropdownButtonSearch(
                      initialValue: filterController.getParams.orderBy,
                      itemList: filterController.orderTypeList(
                        !systemController.properties.accessLocationDenied,
                      ),
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
          Divider(height: 4.0.h, color: AppColors.secondary),
        ],
      ),
    );
  }

  Widget _brazilOrOtherCountriesFilter() {
    return Obx(
      () => Visibility(
        replacement: AutoSizeTexts.autoSizeText12(
          Formatters.cuttedText(DummyData.countrieNames[systemController.properties.userCountryChoice] ?? '', size: 16),
        ),
        visible: systemController.properties.userCountryChoice == defaultCountry,
        child: DropdownButton<String>(
          value: filterController.filterParams.value.state,
          underline: SizedBox(),
          onChanged: (value) {
            filterController.updateParams(
              FilterParamsEnum.state,
              value,
            );
          },
          items: StatesAndCities.stateAndCities.stateInitials
              .map(
                (e) => DropdownMenuItem<String>(
                  child: AutoSizeTexts.autoSizeText12(e),
                  value: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
