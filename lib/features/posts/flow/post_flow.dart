import 'package:tiutiu/features/posts/views/post_caracteristics.dart';
import 'package:tiutiu/features/posts/views/post_description.dart';
import 'package:tiutiu/features/posts/views/post_location.dart';
import 'package:tiutiu/features/posts/views/review_post.dart';
import 'package:tiutiu/features/posts/views/post_info.dart';
import 'package:tiutiu/features/posts/widgets/stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/views/images.dart';
import 'package:tiutiu/core/widgets/row_button_bar.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/features/posts/views/video.dart';
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
          _setMockData();
          List<String> _screensTitle = [
            PostFlowStrings.petsData,
            PostFlowStrings.moreDetails,
            PostFlowStrings.description,
            PostFlowStrings.whereIsIt(
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

          return Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppColors.white,
                body: SizedBox(
                  height: postsController.flowIndex >= 6 ? Get.height / 1.26 : Get.height,
                  child: Column(
                    children: [
                      SizedBox(height: 24.0.h),
                      Steper(
                        currentStep: postsController.flowIndex + (postsController.postReviewed ? 1 : 0),
                        stepsName: _stepsNames,
                      ),
                      _divider(),
                      Obx(
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
                                    fontSize: 32.0,
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
                      ),
                      _divider(),
                      Obx(
                        () => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 4.0.w),
                            child: _stepsScreens.elementAt(
                              postsController.flowIndex,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Obx(
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
                                ? PostFlowStrings.post
                                : AppStrings.contines,
                        textSecond: AppStrings.back,
                      ),
                    );
                  },
                ),
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
  Images(),
  Video(),
  ReviewPost(),
];
