import 'package:tiutiu/features/posts/views/post_description.dart';
import 'package:tiutiu/features/posts/views/post_location.dart';
import 'package:tiutiu/features/posts/views/post_details.dart';
import 'package:tiutiu/features/posts/views/post_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/views/review_post.dart';
import 'package:tiutiu/features/posts/widgets/stepper.dart';
import 'package:tiutiu/features/posts/views/pictures.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/row_button_bar.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFlow extends StatelessWidget with TiuTiuPopUp {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Steper(
              currentStep: postsController.flowIndex,
              stepsName: _stepsNames,
            ),
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
                    fontSize: 16.0.sp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: Row(
                    children: [
                      OneLineText(
                        text: '${postsController.flowIndex + 1}',
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        fontSize: 32.0.sp,
                      ),
                      OneLineText(
                        color: AppColors.black.withAlpha(100),
                        alignment: Alignment.centerRight,
                        text: ' / ${_screensTitle.length}',
                        fontSize: 16.0.sp,
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
              child: _stepsScreens.elementAt(postsController.flowIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => RowButtonBar(
          buttonSecondaryColor:
              postsController.flowIndex < 1 ? AppColors.danger : Colors.grey,
          onPrimaryPressed: () {
            postsController.onContinue();
          },
          onSecondaryPressed: () {
            final showQuestion = !postsController.formIsInInitialState &&
                postsController.flowIndex < 1;

            if (showQuestion) {
              showPopUp(
                message: PostFlowStrings.postCancelMessage,
                title: PostFlowStrings.postCancelTitle,
                mainAction: () => Get.back(),
                confirmText: AppStrings.yes,
                denyText: AppStrings.no,
                secondaryAction: () {
                  Get.back();
                  postsController.previousStep();
                },
                danger: true,
              );
            } else {
              postsController.previousStep();
            }
          },
          textPrimary: AppStrings.contines,
          textSecond: postsController.flowIndex < 1
              ? AppStrings.cancel
              : AppStrings.back,
        ),
      ),
    );
  }

  Divider _divider() => Divider(height: 16.0.h, color: AppColors.secondary);
}

final _stepsNames = [
  PostFlowStrings.data,
  PostFlowStrings.details,
  PetDetailsStrings.description,
  PostFlowStrings.local,
  PostFlowStrings.pcituresAndVideos,
  PostFlowStrings.review,
];

final _screensTitle = [
  PostFlowStrings.petsData,
  PostFlowStrings.moreDetails,
  PostFlowStrings.description,
  PostFlowStrings.whereIsPet,
  PostFlowStrings.insertPictures,
  PostFlowStrings.reviewYourPost,
];

final _stepsScreens = [
  PostInfo(),
  PostDetails(),
  PostDescription(),
  PostLocation(),
  Pictures(),
  ReviewPost()
];
