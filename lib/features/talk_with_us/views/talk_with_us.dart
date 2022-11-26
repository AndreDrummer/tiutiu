import 'package:tiutiu/features/talk_with_us/widgets/body_card.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:tiutiu/features/talk_with_us/model/feedback.dart';
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
              message: feedbackController.loadingText,
              visible: feedbackController.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectYourSubject() {
    final talkWithUsSubjects = [
      FeedbackStrings.wannaAnnounceOnApp,
      FeedbackStrings.writeYourMessage,
      FeedbackStrings.anotherUserIssue,
      FeedbackStrings.dificultsUse,
      FeedbackStrings.partnership,
      DeleteAccountStrings.bugs,
      '-',
    ];

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0.h),
        child: UnderlineInputDropdown(
          labelText: FeedbackStrings.subject,
          isInErrorState:
              !feedbackController.feedback.contactSubject.isNotEmptyNeighterNull() && !feedbackController.isFormValid,
          items: talkWithUsSubjects,
          onChanged: (value) {
            feedbackController.updateFeedback(FeedbackEnum.contactSubject, value);
          },
          initialValue: feedbackController.feedback.contactSubject,
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
          initialValue: feedbackController.feedback.contactMessage,
          onChanged: (message) {
            feedbackController.updateFeedback(FeedbackEnum.contactMessage, message);
          },
          isInErrorState:
              !feedbackController.feedback.contactMessage.isNotEmptyNeighterNull() && !feedbackController.isFormValid,
          labelText: FeedbackStrings.writeYourMessage,
          maxLines: 5,
        ),
      ),
    );
  }

  Widget _addImagesCheckbox() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          feedbackController.insertImages = !feedbackController.insertImages;
        },
        child: AnimatedContainer(
          duration: screenAnimationDuration,
          margin: EdgeInsets.only(
            bottom: !feedbackController.insertImages ? Get.width / 1.15 : 0.0.h,
            top: !feedbackController.insertImages ? 16.0.h : 0.0.h,
          ),
          child: Row(
            children: [
              SizedBox(width: 2.0.w),
              Checkbox(
                value: feedbackController.insertImages,
                onChanged: (_) {
                  feedbackController.insertImages = !feedbackController.insertImages;
                },
              ),
              AutoSizeTexts.autoSizeText16(
                FeedbackStrings.addImages,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _screenshots() {
    final hasErrorOnImages = feedbackController.insertImages && feedbackController.feedback.screenshots.isEmpty;
    final addedImagesQty = feedbackController.feedback.screenshots.length;
    final images = feedbackController.feedback.screenshots;

    return AnimatedOpacity(
      opacity: feedbackController.insertImages ? 1 : 0,
      duration: screenAnimationDuration,
      child: Visibility(
        visible: feedbackController.insertImages,
        child: SizedBox(
          height: 280.0.h,
          child: AddImage(
            onRemovePictureOnIndex: feedbackController.removePictureOnIndex,
            onAddPictureOnIndex: feedbackController.addPictureOnIndex,
            maxImagesQty: feedbackController.maxScreenshots,
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
      onPressed: feedbackController.submitForm,
      isLoading: feedbackController.isLoading,
      text: AppStrings.send,
    );
  }
}
