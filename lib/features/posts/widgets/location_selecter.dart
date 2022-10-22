import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/data/states_and_cities.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView(
        children: [
          SizedBox(height: 16.0.h),
          _stateSelector(),
          _spacer(),
          _citySelector(),
          SizedBox(height: 16.0.h),
          AnimatedContainer(
            margin: EdgeInsets.symmetric(horizontal: 16.0.w),
            height: fillFullAddress ? 164.0.h : 32.0.h,
            duration: Duration(milliseconds: 500),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                _fillFullAddressCheckbox(),
                _fillFullAddressTextArea()
              ],
            ),
          ),
        ],
      ),
    );
  }

  UnderlineInputDropdown _stateSelector() {
    return UnderlineInputDropdown(
      items: StatesAndCities().stateNames,
      labelText: PostFlowStrings.state,
      initialValue: initialState,
      onChanged: onStateChanged,
      fontSize: 12.0.sp,
    );
  }

  UnderlineInputDropdown _citySelector() {
    return UnderlineInputDropdown(
      items: StatesAndCities().citiesOf(stateName: initialState),
      labelText: PostFlowStrings.city,
      initialValue: initialCity,
      onChanged: onCityChanged,
      fontSize: 12.0.sp,
    );
  }

  CheckboxListTile _fillFullAddressCheckbox() {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: AutoSizeText(
        style: TextStyles.fontSize14(
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
        ),
        PostFlowStrings.fillFullAddress,
        maxFontSize: 16,
      ),
      onChanged: onFullAddressSelected,
      value: fillFullAddress,
    );
  }

  Widget _fillFullAddressTextArea() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: 8.0.h),
        child: TextArea(
          onChanged: (address) {
            postsController.updatePet(
              PetEnum.describedAddress,
              address,
            );
          },
          initialValue: postsController.post.describedAddress,
          isInErrorState:
              !postsController.post.describedAddress.isNotEmptyNeighterNull() &&
                  !postsController.formIsValid,
          labelText: PostFlowStrings.typeAddress,
        ),
      ),
    );
  }

  SizedBox _spacer() => SizedBox(height: 32.0.h);
}
