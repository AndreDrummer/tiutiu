import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isDisappeared = (postsController.post as Pet).disappeared;
        final initialValue =
            isDisappeared ? (postsController.post as Pet).lastSeenDetails : postsController.post.describedAddress;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
          child: TextArea(
            labelText: AppLocalizations.of(context)!.jotSomethingDown,
            initialValue: initialValue,
            maxLines: 5,
            onChanged: (textTyped) {
              if (isDisappeared) {
                postsController.updatePost(PetEnum.lastSeenDetails.name, textTyped);
              } else {
                postsController.updatePost(PostEnum.describedAddress.name, textTyped);
              }
            },
          ),
        );
      },
    );
  }
}
