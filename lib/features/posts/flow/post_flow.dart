import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/views/pictures.dart';
import 'package:tiutiu/features/posts/views/post_location.dart';
import 'package:tiutiu/features/posts/views/name_and_age.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/widgets/steper.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/column_button_bar.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostFlow extends StatelessWidget {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: PostFlowStrings.fillAdData),
      body: Stack(
        children: [
          Column(
            children: [
              Obx(
                () => Steper(
                  currentStep: postsController.flowIndex,
                  stepsName: _stepsNames,
                ),
              ),
              Divider(height: 16.0.h),
              Obx(
                () => OneLineText(
                  text: _stepsTitle.elementAt(postsController.flowIndex),
                  alignment: Alignment(-0.9, 1),
                  fontSize: 24.0.sp,
                ),
              ),
              Divider(height: 16.0.h),
              Obx(
                () => Expanded(
                  child: _stepsScreens.elementAt(postsController.flowIndex),
                ),
              ),
            ],
          ),
          Positioned(
            child: ColumnButtonBar(
              onPrimaryPressed: () {
                postsController.onContinue();
              },
              onSecondaryPressed: () {
                postsController.previousStep();
              },
              textPrimary: AppStrings.contines,
              textSecond: postsController.flowIndex < 1
                  ? AppStrings.cancel
                  : AppStrings.back,
            ),
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
          ),
        ],
      ),
    );
  }
}

final _stepsNames = [
  PostFlowStrings.data,
  PostFlowStrings.local,
  PostFlowStrings.pictures,
];

final _stepsTitle = [
  PostFlowStrings.petsData,
  PostFlowStrings.whereIsPet,
  PostFlowStrings.insertPictures,
];

final _stepsScreens = [
  NameAndAge(),
  PostLocation(),
  Pictures(),
];
