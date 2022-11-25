import 'package:tiutiu/features/posts/views/post_caracteristics.dart';
import 'package:tiutiu/features/posts/views/post_description.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/views/post_location.dart';
import 'package:tiutiu/features/posts/views/review_post.dart';
import 'package:tiutiu/features/posts/views/post_info.dart';
import 'package:tiutiu/features/posts/widgets/stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/widgets/cancel_button.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/features/posts/views/video.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/add_image.dart';
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
          _setMockData();
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
            AddImage(
              hasError: postsController.post.photos.isEmpty && !postsController.formIsValid,
              onRemovePictureOnIndex: postsController.removePictureOnIndex,
              onAddPictureOnIndex: postsController.addPictureOnIndex,
              addedImagesQty: postsController.post.photos.length,
              images: postsController.post.photos,
              maxImagesQty: 6,
            ),
            Video(),
            ReviewPost(),
          ];

          return Stack(
            children: [
              Scaffold(
                appBar: _appBar(),
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.white,
                body: SizedBox(
                  height: postsController.flowIndex >= 6 ? Get.height / 1.24 : Get.height,
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

void _setMockData() {
  // if (postsController.post.name == null) {
  //   LocalStorage.getDataUnderKey(key: LocalStorageKey.mockedPost, mapper: Pet())
  //       .then((value) {
  //     if (value != null) {
  //       postsController.post = value as Pet;
  //       print(postsController.post.toMap());
  //     }
  //   });
  // }
}
