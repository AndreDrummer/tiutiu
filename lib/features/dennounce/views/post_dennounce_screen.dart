import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/admob/constants/admob_block_names.dart';
import 'package:tiutiu/features/admob/widgets/ad_banner_300x60.dart';
import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDennounceScreen extends StatelessWidget {
  const PostDennounceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final dennouncePostMotives = postDennounceController.dennouncePostMotives;

        return Scaffold(
          appBar: DefaultBasicAppBar(
            text: postDennounceController.postDennounce.dennouncedPost?.name ?? '',
            backgroundColor: AppColors.secondary,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OneLineText(text: 'Qual motivo da sua denúncia?', fontSize: 18),
              ),
              SizedBox(
                height: Get.height / 4,
                child: ListView.builder(
                  itemCount: dennouncePostMotives.length,
                  itemBuilder: (context, index) {
                    final motive = dennouncePostMotives[index];

                    return RadioListTile(
                      groupValue: postDennounceController.postDennounceGroupValue,
                      value: dennouncePostMotives.indexOf(motive),
                      title: AutoSizeTexts.autoSizeText14(motive),
                      activeColor: AppColors.secondary,
                      onChanged: (value) {
                        final postDennounce = postDennounceController.postDennounce;
                        postDennounceController.hasError = false;

                        postDennounce.copyWith(motive: dennouncePostMotives[value!]);

                        postDennounceController.updatePostDennounce = postDennounce;
                        postDennounceController.postDennounceGroupValue = value;
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: postDennounceController.postDennounce.motive == PostDennounceStrings.other,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextArea(
                    isInErrorState: postDennounceController.hasError,
                    labelText: 'Especifique o motivo da denúnia',
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0.h),
                child: ButtonWide(
                  color: AppColors.secondary,
                  onPressed: () {
                    postDennounceController.hasError =
                        postDennounceController.postDennounce.motive == PostDennounceStrings.other &&
                            !postDennounceController.postDennounce.description.isNotEmptyNeighterNull();

                    if (!postDennounceController.hasError) {
                      print(postDennounceController.postDennounce);
                    }
                  },
                  text: 'Denunciar',
                ),
              ),
              AdBanner300x60(adBlockName: AdMobBlockName.postDetailsScreen)
            ],
          ),
        );
      },
    );
  }
}
