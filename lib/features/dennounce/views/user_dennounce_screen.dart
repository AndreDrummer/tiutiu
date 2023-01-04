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
      final hasError = userDennounceController.hasError;

      return DennouncePopup(
        padding: (keyboardIsVisible) => _defaultPadding(
          keyboardIsVisible: keyboardIsVisible,
          motiveIsOther: motiveIsOther,
          hasError: hasError,
        ),
        groupValue: userDennounceController.userDennounceGroupValue,
        contentHeight: Dimensions.getDimensBasedOnDeviceHeight(
          xSmaller: motiveIsOther
              ? hasError
                  ? Get.height / 2.1
                  : Get.height / 2.2
              : Get.height / 4.0,
          smaller: motiveIsOther
              ? hasError
                  ? Get.height / 2.2
                  : Get.height / 2.4
              : Get.height / 4.0,
          medium: motiveIsOther
              ? hasError
                  ? Get.width / 1.33
                  : Get.height / 3.1
              : Get.height / 5.0,
          bigger: motiveIsOther
              ? hasError
                  ? Get.width / 1.45
                  : Get.height / 3.4
              : Get.height / 6.0,
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

  EdgeInsetsGeometry _defaultPadding({
    required bool keyboardIsVisible,
    required bool motiveIsOther,
    required bool hasError,
  }) {
    return EdgeInsets.only(
      bottom: Dimensions.getDimensBasedOnDeviceHeight(
        xSmaller: keyboardIsVisible
            ? Get.width / 2.25
            : motiveIsOther
                ? hasError
                    ? Get.width / 4.0
                    : Get.width / 3.6
                : Get.width / 2.0,
        smaller: keyboardIsVisible ? Get.width / 1.4 : Get.width / 2.5,
        medium: keyboardIsVisible
            ? Get.width / 1.25
            : motiveIsOther
                ? hasError
                    ? Get.width / 3.0
                    : Get.width / 2.5
                : Get.width / 2.0,
        bigger: keyboardIsVisible
            ? Get.width * .825
            : motiveIsOther
                ? Get.width / 3.2
                : Get.width / 2,
      ),
      top: Dimensions.getDimensBasedOnDeviceHeight(
        xSmaller: keyboardIsVisible
            ? 0
            : motiveIsOther
                ? _topPadding(hasError, keyboardIsVisible)
                : Get.width / 3.0,
        bigger: motiveIsOther
            ? _topPadding(hasError, keyboardIsVisible)
            : keyboardIsVisible
                ? Get.width / 1.225
                : Get.width / 1.3,
        smaller: motiveIsOther
            ? _topPadding(hasError, keyboardIsVisible)
            : keyboardIsVisible
                ? Get.width / 2.5
                : Get.width / 2.0,
        medium: motiveIsOther
            ? _topPadding(hasError, keyboardIsVisible)
            : keyboardIsVisible
                ? Get.width / 1.5
                : Get.width / 1.3,
      ),
      right: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 32.0.w,
        bigger: 56.0.w,
        medium: 56.0.w,
      ),
      left: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 32.0.w,
        bigger: 56.0.w,
        medium: 56.0.w,
      ),
    );
  }

  double _topPadding(bool hasError, bool keyboardIsVisible) {
    return Dimensions.getDimensBasedOnDeviceHeight(
      smaller: hasError ? Get.width * .65 : Get.width * .225,
      bigger: hasError ? Get.width * .65 : Get.width * .725,
      medium: hasError ? Get.width * .65 : Get.width * .625,
    );
  }
}
