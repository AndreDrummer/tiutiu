import 'package:tiutiu/features/dennounce/widgets/dennonuce_popup_content.dart';
import 'package:tiutiu/features/dennounce/model/user_dennounce.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
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

      return DennouncePopupContent(
        groupValue: userDennounceController.userDennounceGroupValue,
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
          userDennounceController.resetForm();
        },
        motiveIsOther: motiveIsOther,
        dennounceMotives: motives,
      );
    });
  }

  void _onUpdateUserDennounceMotive(int? index) {
    int motiveIndex = index ?? 0;

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
        Get.back();

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
}
