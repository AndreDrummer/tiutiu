import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/features/posts/flow/3_post_caracteristics.dart';
import 'package:tiutiu/features/posts/flow/2_post_description.dart';
import 'package:tiutiu/features/posts/flow/4_post_location.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/flow/5_post_images.dart';
import 'package:tiutiu/features/posts/flow/7_review_post.dart';
import 'package:tiutiu/features/posts/flow/6_post_video.dart';
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
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFlow extends StatelessWidget with TiuTiuPopUp {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(
        () {
          final isCardVisibilityKind = homeController.cardVisibilityKind == CardVisibilityKind.card;

          List<String> _screensTitle = [
            PostFlowStrings.petsData,
            PostFlowStrings.moreDetails,
            PostFlowStrings.otherCaracteristicsOptional,
            PostFlowStrings.whereIsIt(
              isDisappeared: (postsController.post as Pet).disappeared,
              petGender: (postsController.post as Pet).gender,
              petName: '${postsController.post.name}',
            ),
            PostFlowStrings.picTime,
            PostFlowStrings.addVideo,
            postsController.postReviewed
                ? postsController.isLoading
                    ? PostFlowStrings.posting
                    : PostFlowStrings.allDone
                : PostFlowStrings.reviewYourPost,
          ];

          final _stepsNames = [
            PostFlowStrings.data,
            PostFlowStrings.details,
            PostFlowStrings.otherCaracteristics,
            PostFlowStrings.local,
            PostFlowStrings.pictures,
            PostFlowStrings.videos,
            PostFlowStrings.review,
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
                floatingActionButton: ChangePostsVisibilityFloatingButtom(visibility: postsController.flowIndex >= 6),
                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                appBar: _appBar(),
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.white,
                body: Container(
                  alignment: Alignment.center,
                  height: Get.height / (isCardVisibilityKind ? 1.45 : 2.9),
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
                bottomNavigationBar: _flowBottom(),
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

  AppBar _appBar() {
    return DefaultBasicAppBar(
      text: postsController.isEditingPost ? PostFlowStrings.editAd : PostFlowStrings.post,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0.w),
          child: SimpleTextButton(
            text: AppStrings.cancel,
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
                  fontSize: 24.0,
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

  Widget _flowBottom() {
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
                ? PostFlowStrings.reviewButton
                : postsController.lastStep()
                    ? postsController.isEditingPost
                        ? PostFlowStrings.postUpdate
                        : PostFlowStrings.post
                    : AppStrings.contines,
            textSecond: AppStrings.back,
          ),
        );
      },
    );
  }

  Divider _divider() => Divider(height: 16.0.h, color: AppColors.secondary);
}
