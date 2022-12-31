import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDennounceScreen extends StatelessWidget {
  const PostDennounceScreen({
    required this.onDennounce,
    required this.onCancel,
    super.key,
  });

  final Function()? onDennounce;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    final dennouncePostMotives = postDennounceController.dennouncePostMotives;

    return Obx(() {
      final motiveIsOther = postDennounceController.postDennounce.motive == PostDennounceStrings.other;

      return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(
          bottom: motiveIsOther ? Get.width / 3.3 : Get.width / 3,
          top: motiveIsOther ? Get.width * .75 : Get.width,
          right: 56.0.w,
          left: 56.0.w,
        ),
        height: Get.height,
        width: Get.width,
        color: AppColors.black.withOpacity(.4),
        child: Card(
          elevation: 16.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.h),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0.h),
              color: AppColors.white,
            ),
            height: motiveIsOther ? Get.width * 1.15 : Get.width / 1.17,
            margin: EdgeInsets.zero,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OneLineText(text: 'Qual motivo da sua denúncia?', fontSize: 18),
                ),
                Divider(),
                SizedBox(
                  height: Get.height / 4,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: dennouncePostMotives.length,
                    itemBuilder: (context, index) {
                      final motive = dennouncePostMotives[index];

                      return Obx(
                        () => RadioListTile(
                          groupValue: postDennounceController.postDennounceGroupValue,
                          value: dennouncePostMotives.indexOf(motive),
                          title: AutoSizeTexts.autoSizeText14(motive),
                          activeColor: AppColors.secondary,
                          onChanged: (value) {
                            postDennounceController.postDennounceGroupValue = value!;
                            postDennounceController.hasError = false;

                            postDennounceController.updatePostDennounce(
                              PostDennounceEnum.motive,
                              dennouncePostMotives[value],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: motiveIsOther,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0.w),
                    child: TextArea(
                      isInErrorState: postDennounceController.hasError,
                      labelText: 'Especifique o motivo',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            onDennounce?.call();
                            print('DDD ${postDennounceController.postDennounce.toMap()}');
                          },
                          child: AutoSizeTexts.autoSizeText14(AppStrings.cancel)),
                      TextButton(
                        onPressed: onDennounce,
                        child: AutoSizeTexts.autoSizeText14(
                          PostDennounceStrings.dennounce,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
