import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoToPostButton extends StatelessWidget {
  const GoToPostButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.height < 700 ? 56.0.h : 32.0.h,
      right: Dimensions.getDimensBasedOnDeviceHeight(
        smaller: 8.0.w,
        bigger: 0.0.w,
        xBigger: 8.0.w,
        medium: 8.0.w,
      ),
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.only(right: 16.0.w)),
        onPressed: () {
          postsController.post = post;
          Get.toNamed(Routes.postDetails);
        },
        child: AutoSizeTexts.autoSizeText14(
          AppLocalizations.of(context).seeDetails,
          textAlign: TextAlign.end,
          color: AppColors.white,
        ),
      ),
    );
  }
}
