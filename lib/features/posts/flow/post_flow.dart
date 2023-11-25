import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/posts/flow/3_post_caracteristics.dart';
import 'package:tiutiu/features/posts/flow/2_post_description.dart';
import 'package:tiutiu/features/posts/flow/4_post_location.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/flow/5_post_images.dart';
import 'package:tiutiu/features/posts/flow/7_review_post.dart';
import 'package:tiutiu/features/posts/flow/6_post_video.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/simple_text_button.dart';
import 'package:tiutiu/features/posts/flow/1_post_info.dart';
import 'package:tiutiu/features/posts/widgets/stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFlow extends StatelessWidget with TiuTiuPopUp {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async => false,
      child: Obx(
        () {
          double screenHeight = postsController.flowIndex >= 6 ? Get.height / 1.39 : Get.height;
          final isDisappeared = (postsController.post as Pet).disappeared;
          final postReviewed = postsController.postReviewed;

          List<String> _screensTitle = [
            AppLocalizations.of(context)!.petsData,
            AppLocalizations.of(context)!.moreDetails,
            AppLocalizations.of(context)!.otherCaracteristicsOptional,
            isDisappeared
                ? AppLocalizations.of(context)!.whereLastSeen
                : AppLocalizations.of(context)!.provideAddressDetails,
            AppLocalizations.of(context)!.picTime,
            AppLocalizations.of(context)!.addVideo,
            postReviewed
                ? postsController.isLoading
                    ? AppLocalizations.of(context)!.posting
                    : AppLocalizations.of(context)!.allDone
                : AppLocalizations.of(context)!.reviewYourPost,
          ];

          final _stepsNames = [
            AppLocalizations.of(context)!.data,
            AppLocalizations.of(context)!.details,
            AppLocalizations.of(context)!.otherCaracteristics,
            AppLocalizations.of(context)!.local,
            AppLocalizations.of(context)!.pictures,
            AppLocalizations.of(context)!.videos,
            AppLocalizations.of(context)!.review,
          ];

          List<Widget> _stepsScreens = [
            PostInfo(),
            PostDescription(),
            PostCaracteristics(),
            PostLocation(),
            PostImages(),
            PostVideo(),
            ReviewPost(),
          ];

          return Stack(
            children: [
              Scaffold(
                appBar: _appBar(context),
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.white,
                body: Container(
                  alignment: Alignment.center,
                  height: screenHeight,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Steper(
                          currentStep: postsController.flowIndex + (postsController.postReviewed ? 1 : 0),
                          stepsName: _stepsNames,
                        ),
                      ),
                      _divider(),
                      _flowTitle(_screensTitle),
                      _divider(),
                      _flowBody(_stepsScreens),
                    ],
                  ),
                ),
                bottomNavigationBar: _flowBottom(context),
              ),
              Positioned(
                child: ChangePostsVisibilityFloatingButtom(visibility: postsController.flowIndex >= 6),
                bottom: 76.0.h,
                right: 0.0.w,
                left: 0.0.w,
              ),
              LoadDarkScreen(
                message: postsController.uploadingPostText,
                visible: postsController.isLoading,
              )
            ],
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return DefaultBasicAppBar(
      text: postsController.isEditingPost ? AppLocalizations.of(context)!.editAd : AppLocalizations.of(context)!.post,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0.w),
          child: SimpleTextButton(
            text: AppLocalizations.of(context)!.cancel,
            onPressed: () async {
              await postsController.showsCancelPostPopUp(isInsideFlow: true).then((shouldGoBack) {
                if (shouldGoBack) Get.back();
              });
            },
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _flowTitle(List<String> _screensTitle) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0.w),
            child: OneLineText(
              text: _screensTitle.elementAt(postsController.flowIndex),
              fontSize: 16.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.0.w),
            child: Row(
              children: [
                OneLineText(
                  text: '${postsController.flowIndex + (postsController.postReviewed ? 1 : 1)}',
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  fontSize: 22.0,
                ),
                OneLineText(
                  color: AppColors.black.withAlpha(100),
                  widgetAlignment: Alignment.centerRight,
                  text: ' / ${_screensTitle.length}',
                  fontSize: 16.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _flowBody(List<Widget> _stepsScreens) {
    return Obx(
      () => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: 4.0.w),
          child: _stepsScreens.elementAt(
            postsController.flowIndex,
          ),
        ),
      ),
    );
  }

  Widget _flowBottom(BuildContext context) {
    return Obx(
      () {
        return Container(
          color: AppColors.white,
          margin: EdgeInsets.only(bottom: 8.0.h),
          child: RowButtonBar(
            isLoading: postsController.isLoading,
            buttonSecondaryColor: Colors.grey,
            onPrimaryPressed: () {
              if (postsController.isInStepReview()) {
                postsController.reviewPost();
              } else if (postsController.lastStep()) {
                postsController.uploadPost();
              } else {
                postsController.nextStepFlow();
              }
            },
            onSecondaryPressed: () {
              postsController.previousStepFlow();
            },
            textPrimary: postsController.isInStepReview()
                ? AppLocalizations.of(context)!.reviewButton
                : postsController.lastStep()
                    ? postsController.isEditingPost
                        ? AppLocalizations.of(context)!.postUpdate
                        : AppLocalizations.of(context)!.post
                    : AppLocalizations.of(context)!.contines,
            textSecond: AppLocalizations.of(context)!.back,
          ),
        );
      },
    );
  }

  Divider _divider() => Divider(height: 16.0.h, color: AppColors.secondary);
}
