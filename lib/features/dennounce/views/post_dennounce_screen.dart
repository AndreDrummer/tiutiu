import 'package:tiutiu/features/dennounce/widgets/dennonuce_popup_content.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDennounceScreen extends StatelessWidget {
  const PostDennounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final motiveIsOther = postDennounceController.postDennounce.motive == AppLocalizations.of(context)!.other;
      final denounceDescription = postDennounceController.postDennounce.description;
      final motives = postDennounceController.dennouncePostMotives;

      return DennouncePopupContent(
        onSubmit: () {
          _onSubmitPostDennounce(context, motiveIsOther);
        },
        groupValue: postDennounceController.postDennounceGroupValue,
        isLoading: postDennounceController.isLoading,
        onMotiveUpdate: _onUpdatePostDennounceMotive,
        hasError: postDennounceController.hasError,
        denounceDescription: denounceDescription,
        dennounceMotives: motives,
        onMotiveDescribed: (motiveDescription) {
          if (motiveDescription.length >= 3) {
            postDennounceController.hasError = false;
          }

          postDennounceController.updatePostDennounce(PostDennounceEnum.description, motiveDescription);
        },
        cancel: () {
          postDennounceController.resetForm();
          postDennounceController.setLoading(false);
        },
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
        Get.back();

        ScaffoldMessenger.of(context).showSnackBar(
          TiuTiuSnackBar(message: AppLocalizations.of(context)!.dennounceSentSuccessfully),
        );
      });
    } else {
      postDennounceController.hasError = true;
    }
  }
}
