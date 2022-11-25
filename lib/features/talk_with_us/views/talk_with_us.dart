import 'package:tiutiu/features/talk_with_us/model/talk_with_us.dart';
import 'package:tiutiu/features/talk_with_us/widgets/body_card.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/widgets/add_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TalkWithUs extends StatelessWidget {
  TalkWithUs({super.key});
  final screenAnimationDuration = Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: MyProfileOptionsTile.talkWithUs),
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Stack(
          children: [
            BodyCard(
              child: ListView(
                children: [
                  _selectYourSubject(),
                  _describeYourMessage(),
                  _addImagesCheckbox(),
                  _screenshots(),
                  _submitButton()
                ],
              ),
            ),
            LoadDarkScreen(
              message: talkWithUsController.loadingText,
              visible: talkWithUsController.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectYourSubject() {
    final talkWithUsSubjects = [
      TalkWithUsStrings.wannaAnnounceOnApp,
      TalkWithUsStrings.writeYourMessage,
      TalkWithUsStrings.anotherUserIssue,
      TalkWithUsStrings.dificultsUse,
      TalkWithUsStrings.partnership,
      DeleteAccountStrings.bugs,
      '-',
    ];

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0.h),
        child: UnderlineInputDropdown(
          labelText: TalkWithUsStrings.subject,
          isInErrorState: !talkWithUsController.talkWithUs.contactSubject.isNotEmptyNeighterNull() &&
              !talkWithUsController.isFormValid,
          items: talkWithUsSubjects,
          onChanged: (value) {
            talkWithUsController.updateTalkWithUs(TalkWithUsEnum.contactSubject, value);
          },
          initialValue: talkWithUsController.talkWithUs.contactSubject,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _describeYourMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0.w),
      child: Obx(
        () => TextArea(
          initialValue: talkWithUsController.talkWithUs.contactMessage,
          onChanged: (message) {
            talkWithUsController.updateTalkWithUs(TalkWithUsEnum.contactMessage, message);
          },
          isInErrorState: !talkWithUsController.talkWithUs.contactMessage.isNotEmptyNeighterNull() &&
              !talkWithUsController.isFormValid,
          labelText: TalkWithUsStrings.writeYourMessage,
          maxLines: 5,
        ),
      ),
    );
  }

  Widget _addImagesCheckbox() {
    return Obx(
      () => AnimatedContainer(
        duration: screenAnimationDuration,
        margin: EdgeInsets.only(
          bottom: !talkWithUsController.insertImages ? Get.width / 1.15 : 0.0.h,
          top: !talkWithUsController.insertImages ? 16.0.h : 0.0.h,
        ),
        child: Row(
          children: [
            SizedBox(width: 2.0.w),
            Checkbox(
              value: talkWithUsController.insertImages,
              onChanged: (_) {
                talkWithUsController.insertImages = !talkWithUsController.insertImages;
              },
            ),
            AutoSizeTexts.autoSizeText16(
              TalkWithUsStrings.addImages,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            )
          ],
        ),
      ),
    );
  }

  Widget _screenshots() {
    final hasErrorOnImages = talkWithUsController.insertImages && talkWithUsController.talkWithUs.screenshots.isEmpty;
    final addedImagesQty = talkWithUsController.talkWithUs.screenshots.length;
    final images = talkWithUsController.talkWithUs.screenshots;

    return AnimatedOpacity(
      opacity: talkWithUsController.insertImages ? 1 : 0,
      duration: screenAnimationDuration,
      child: Visibility(
        visible: talkWithUsController.insertImages,
        child: SizedBox(
          height: 280.0.h,
          child: AddImage(
            onRemovePictureOnIndex: talkWithUsController.removePictureOnIndex,
            onAddPictureOnIndex: talkWithUsController.addPictureOnIndex,
            maxImagesQty: talkWithUsController.maxScreenshots,
            addedImagesQty: addedImagesQty,
            hasError: hasErrorOnImages,
            images: images,
          ),
        ),
      ),
    );
  }

  ButtonWide _submitButton() {
    return ButtonWide(
      onPressed: talkWithUsController.submitForm,
      isLoading: talkWithUsController.isLoading,
      text: AppStrings.send,
    );
  }
}
