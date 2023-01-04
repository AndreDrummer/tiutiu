import 'package:tiutiu/features/dennounce/widgets/dennonuce_popup.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDennounceScreen extends StatelessWidget {
  const PostDennounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final motiveIsOther = postDennounceController.postDennounce.motive == PostDennounceStrings.other;
      final denounceDescription = postDennounceController.postDennounce.description;
      final motives = postDennounceController.dennouncePostMotives;
      final hasError = postDennounceController.hasError;

      return DennouncePopup(
        onSubmit: () => _onSubmitPostDennounce(context, motiveIsOther),
        groupValue: postDennounceController.postDennounceGroupValue,
        isLoading: postDennounceController.isLoading,
        onMotiveUpdate: _onUpdatePostDennounceMotive,
        hasError: postDennounceController.hasError,
        denounceDescription: denounceDescription,
        dennounceMotives: motives,
        contentHeight: Dimensions.getDimensBasedOnDeviceHeight(
          xSmaller: motiveIsOther
              ? hasError
                  ? Get.height / 2.35
                  : Get.height / 2.5
              : Get.height / 4.0,
          smaller: motiveIsOther
              ? hasError
                  ? Get.height / 1.85
                  : Get.height / 2.0
              : Get.height / 3.0,
          bigger: motiveIsOther
              ? hasError
                  ? Get.height / 2.35
                  : Get.height / 2.5
              : Get.height / 4.0,
          medium: motiveIsOther
              ? hasError
                  ? Get.height / 2.35
                  : Get.height / 2.5
              : Get.height / 4.0,
        ),
        onMotiveDescribed: (motiveDescription) {
          if (motiveDescription.length >= 3) {
            postDennounceController.hasError = false;
          }

          postDennounceController.updatePostDennounce(PostDennounceEnum.description, motiveDescription);
        },
        cancel: () {
          postDennounceController.resetForm();
          postDennounceController.hidePopup();
        },
        show: postDennounceController.popupIsVisble,
        motiveIsOther: motiveIsOther,
      );
    });
  }

  void _onUpdatePostDennounceMotive(int? index) {
    int motiveIndex = index ?? 0;

    final dennouncePostMotives = postDennounceController.dennouncePostMotives;
    postDennounceController.postDennounceGroupValue = motiveIndex;
    postDennounceController.hasError = false;

    postDennounceController.updatePostDennounce(PostDennounceEnum.motive, dennouncePostMotives[motiveIndex]);
  }

  Future<void> _onSubmitPostDennounce(BuildContext context, bool motiveIsOther) async {
    final postDennounce = postDennounceController.postDennounce;

    final formIsValid = motiveIsOther ? postDennounce.description.isNotEmptyNeighterNull() : true;

    if (formIsValid) {
      postDennounceController.hasError = false;
      postDennounceController.submit().then((_) {
        postDennounceController.hidePopup();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AutoSizeTexts.autoSizeText14(DennounceStrings.dennounceSentSuccessfully),
            duration: Duration(milliseconds: 1500),
            backgroundColor: AppColors.info,
          ),
        );
      });
    } else {
      postDennounceController.hasError = true;
    }
  }
}
