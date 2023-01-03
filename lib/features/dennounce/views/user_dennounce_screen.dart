import 'package:tiutiu/features/dennounce/widgets/dennonuce_popup.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDennounceScreen extends StatelessWidget {
  const UserDennounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final motiveIsOther = userDennounceController.userDennounce.motive == UserDennounceStrings.other;
      final denounceDescription = userDennounceController.userDennounce.description;
      final motives = userDennounceController.dennounceUserMotives;

      return DennouncePopup(
        groupValue: userDennounceController.userDennounceGroupValue,
        contentHeight: Dimensions.getDimensBasedOnDeviceHeight(
          smaller: Get.height / (motives.length * 1.3),
          medium: Get.height / 5.5,
          bigger: Get.height / 6,
        ),
        padding: EdgeInsets.only(
          bottom: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: motiveIsOther ? Get.width / 4.5 : Get.width / 3.0,
            medium: motiveIsOther ? Get.width / 3.2 : Get.width / 2,
            bigger: Get.width / 2.1,
          ),
          top: Dimensions.getDimensBasedOnDeviceHeight(
            bigger: motiveIsOther ? _topPadding(userDennounceController.hasError) : Get.width / 1.25,
            smaller: motiveIsOther ? Get.width / 4.25 : Get.width / 2.25,
            medium: motiveIsOther ? Get.width * .65 : Get.width / 1.2,
          ),
          right: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: 56.0.w,
            bigger: 56.0.w,
            medium: 56.0.w,
          ),
          left: Dimensions.getDimensBasedOnDeviceHeight(
            smaller: 56.0.w,
            bigger: 56.0.w,
            medium: 56.0.w,
          ),
        ),
        dennounceMotives: motives,
        onSubmit: () => _onSubmitUserDennounce(context, motiveIsOther),
        isLoading: userDennounceController.isLoading,
        onMotiveUpdate: _onUpdateUserDennounceMotive,
        hasError: userDennounceController.hasError,
        denounceDescription: denounceDescription,
        onMotiveDescribed: (motiveDescription) {
          if (motiveDescription.length >= 3) {
            userDennounceController.hasError = false;
          }

          userDennounceController.updateUserDennounce(UserDennounceEnum.description, motiveDescription);
        },
        cancel: () {
          userDennounceController.hidePopup();
          userDennounceController.resetForm();
        },
        motiveIsOther: motiveIsOther,
        show: userDennounceController.popupIsVisible,
      );
    });
  }

  void _onUpdateUserDennounceMotive(int? index) {
    int motiveIndex = index ?? 0;

    print(index);

    final dennounceUserMotives = userDennounceController.dennounceUserMotives;
    userDennounceController.userDennounceGroupValue = motiveIndex;
    userDennounceController.hasError = false;

    userDennounceController.updateUserDennounce(UserDennounceEnum.motive, dennounceUserMotives[motiveIndex]);
  }

  Future<void> _onSubmitUserDennounce(BuildContext context, bool motiveIsOther) async {
    final userDennounce = userDennounceController.userDennounce;

    final formIsValid = motiveIsOther ? userDennounce.description.isNotEmptyNeighterNull() : true;

    if (formIsValid) {
      userDennounceController.hasError = false;
      userDennounceController.submit().then((_) {
        userDennounceController.hidePopup();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AutoSizeTexts.autoSizeText14(DennounceStrings.dennounceSentSuccessfully),
            duration: Duration(milliseconds: 1500),
            backgroundColor: AppColors.info,
          ),
        );
      });
    } else {
      userDennounceController.hasError = true;
    }
  }

  double _topPadding(bool hasError) {
    return Dimensions.getDimensBasedOnDeviceHeight(
      smaller: hasError ? Get.width * .65 : Get.width * .225,
      bigger: hasError ? Get.width * .65 : Get.width * .725,
      medium: hasError ? Get.width * .65 : Get.width * .625,
    );
  }
}
