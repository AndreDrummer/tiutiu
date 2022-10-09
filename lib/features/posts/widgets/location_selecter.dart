import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/data/location_data_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class LocationSelecter extends StatelessWidget {
  const LocationSelecter({
    required this.onFullAddressSelected,
    this.fillFullAddress = false,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.initialState,
    required this.initialCity,
    super.key,
  });

  final Function(bool?) onFullAddressSelected;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;
  final bool fillFullAddress;
  final String initialState;
  final String initialCity;

  Future<void> loadStatesAndCities() async {
    await DataLocalStrings().getUFAndCities();
  }

  void updateState(String? stateName) {
    onStateChanged(stateName);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(height: 16.0.h),
          UnderlineInputDropdown(
            items: DataLocalStrings().stateNames,
            labelText: PostFlowStrings.state,
            initialValue: initialState,
            onChanged: updateState,
            fontSize: 12.0.sp,
          ),
          SizedBox(height: 24.0.h),
          UnderlineInputDropdown(
            items: DataLocalStrings().citiesOf(
              stateName: initialState,
            ),
            labelText: PostFlowStrings.city,
            initialValue: initialCity,
            onChanged: onCityChanged,
            fontSize: 12.0.sp,
          ),
          SizedBox(height: 32.0.h),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            margin: EdgeInsets.symmetric(horizontal: 16.0.w),
            height: fillFullAddress ? 164.0.h : 32.0.h,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      PostFlowStrings.fillFullAddress,
                      style: TextStyles.fontSize14(),
                    ),
                    Transform.scale(
                      scale: 1.0.h,
                      child: Checkbox(
                        onChanged: onFullAddressSelected,
                        value: fillFullAddress,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0.h),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: PostFlowStrings.typeAddress,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0.h),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
