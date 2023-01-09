import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/location/models/states_and_cities.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/posts/model/post.dart';
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
        padding: EdgeInsets.only(top: 16.0.h),
        children: [
          _stateSelector(),
          _divider(),
          _citySelector(),
          AnimatedContainer(
            margin: EdgeInsets.symmetric(horizontal: 16.0.w),
            height: fillFullAddress ? 172.0.h : 52.0.h,
            duration: Duration(milliseconds: 500),
            child: ListView(
              padding: EdgeInsets.only(top: 8.0.h),
              physics: NeverScrollableScrollPhysics(),
              children: [
                _fillAddressComplimentCheckbox(),
                _fillAddressComplimentTextArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  UnderlineInputDropdown _stateSelector() {
    return UnderlineInputDropdown(
      items: StatesAndCities.stateAndCities.stateNames,
      labelText: PostFlowStrings.state,
      initialValue: initialState,
      onChanged: onStateChanged,
      fontSize: 12.0,
    );
  }

  UnderlineInputDropdown _citySelector() {
    return UnderlineInputDropdown(
      items: StatesAndCities.stateAndCities.citiesOf(stateName: initialState),
      labelText: PostFlowStrings.city,
      initialValue: initialCity,
      onChanged: onCityChanged,
      fontSize: 12.0,
    );
  }

  CheckboxListTile _fillAddressComplimentCheckbox() {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: AutoSizeTexts.autoSizeText16(
        (postsController.post as Pet).disappeared
            ? PostFlowStrings.provideMoreDetails
            : PostFlowStrings.fillFullAddress,
        fontWeight: FontWeight.w500,
        color: AppColors.secondary,
      ),
      onChanged: onFullAddressSelected,
      value: fillFullAddress,
    );
  }

  Widget _fillAddressComplimentTextArea() {
    return Obx(
      () {
        bool isDisappeared = (postsController.post as Pet).disappeared;
        bool isInErrorState = isDisappeared &&
                !(postsController.post as Pet).lastSeenDetails.isNotEmptyNeighterNull() &&
                !postsController.formIsValid ||
            !isDisappeared &&
                !postsController.post.describedAddress.isNotEmptyNeighterNull() &&
                !postsController.formIsValid;

        return Padding(
          padding: EdgeInsets.zero,
          child: TextArea(
            onChanged: (address) {
              if ((postsController.post as Pet).disappeared) {
                postsController.updatePost(
                  PetEnum.lastSeenDetails.name,
                  address,
                );
              } else {
                postsController.updatePost(
                  PostEnum.describedAddress.name,
                  address.trim(),
                );
              }
            },
            initialValue:
                isDisappeared ? (postsController.post as Pet).lastSeenDetails : postsController.post.describedAddress,
            isInErrorState: isInErrorState,
            labelText:
                (postsController.post as Pet).disappeared ? AppStrings.jotSomethingDown : PostFlowStrings.typeAddress,
          ),
        );
      },
    );
  }

  SizedBox _divider() => SizedBox(height: 32.0.h);
}
