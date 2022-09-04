import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterResultCount extends StatelessWidget {
  const FilterResultCount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 24.0.h,
        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
        margin: EdgeInsets.only(bottom: 4.0.h),
        child: Row(
          children: [
            Row(
              children: [
                AutoSizeText(
                  '${petsController.petsCount} ',
                  style: TextStyles.fontSize12(),
                ),
                AutoSizeText(
                  'encontrados em ',
                  style: TextStyles.fontSize12(),
                ),
              ],
            ),
            Spacer(),
            DropdownButton<String>(
              underline: SizedBox(),
              onChanged: (value) {},
              value: DummyData.statesInitials.first,
              items: DummyData.statesInitials
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
                  'ordenados por:  ',
                  style: TextStyles.fontSize12(),
                ),
                CustomDropdownButtonSearch(
                  colorText: Colors.black54,
                  fontSize: 13,
                  initialValue: petsController.orderType,
                  isExpanded: false,
                  withPipe: false,
                  itemList: petsController.orderTypeList,
                  label: '',
                  onChange: (String text) {
                    petsController.changeOrderType(
                      text,
                      'null',
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
