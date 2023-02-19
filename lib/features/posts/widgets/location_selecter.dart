import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
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
        padding: EdgeInsets.all(8.0.h),
        physics: NeverScrollableScrollPhysics(),
        children: [
          Visibility(
            visible: (postsController.post as Pet).disappeared,
            child: _fillAddressComplimentTextArea(context),
            replacement: _descriptionInputText(context),
          ),
          Divider(),
          Visibility(
            visible: (postsController.post as Pet).disappeared,
            replacement: _fillAddressComplimentTextArea(context),
            child: _descriptionInputText(context),
          ),
        ],
      ),
    );
  }

  Widget _fillAddressComplimentTextArea(BuildContext context) {
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
            maxLines: 4,
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
            labelText: (postsController.post as Pet).disappeared
                ? AppLocalizations.of(context).jotSomethingDown
                : AppLocalizations.of(context).typeAddress,
          ),
        );
      },
    );
  }

  Widget _descriptionInputText(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
        child: TextArea(
          isInErrorState: !postsController.post.description.isNotEmptyNeighterNull() && !postsController.formIsValid,
          initialValue: postsController.post.description,
          labelText: (postsController.post as Pet).disappeared
              ? AppLocalizations.of(context).talkAboutThisPet
              : AppLocalizations.of(context).jotSomethingDown,
          maxLines: 4,
          onChanged: (description) {
            postsController.updatePost(PostEnum.description.name, description);
          },
        ),
      ),
    );
  }
}
