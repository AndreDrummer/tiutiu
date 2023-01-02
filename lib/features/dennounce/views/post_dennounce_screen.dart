import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/features/dennounce/widgets/dennonuce_popup.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDennounceScreen extends StatelessWidget {
  const PostDennounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final motiveIsOther = postDennounceController.postDennounce.motive == PostDennounceStrings.other;
      final denounceDescription = postDennounceController.postDennounce.description;

      return DennouncePopup(
        groupValue: postDennounceController.postDennounceGroupValue,
        dennounceMotives: postDennounceController.dennouncePostMotives,
        onSubmit: () => _onSubmitPostDennounce(context, motiveIsOther),
        isLoading: postDennounceController.isLoading,
        onMotiveUpdate: _onUpdatePostDennounceMotive,
        hasError: postDennounceController.hasError,
        denounceDescription: denounceDescription,
        contentHeight: Dimensions.getDimensBasedOnDeviceHeight(
          smaller: Get.height / 4.2,
          bigger: Get.height / 4.2,
          medium: Get.height / 4.0,
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
