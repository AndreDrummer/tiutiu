import 'package:tiutiu/features/dennounce/model/post_dennounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DennounceButton extends StatelessWidget with TiuTiuPopUp {
  const DennounceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopUp(
          message: 'Deseja denunciar este anúncio?',
          confirmText: AppStrings.yes,
          textColor: AppColors.black,
          denyText: AppStrings.no,
          title: 'Denúncia',
          warning: true,
          mainAction: () {
            Get.back();
          },
          secondaryAction: () {
            print('Denounce');
            Get.back();

            postDennounceController.updatePostDennounce(
              PostDennounceEnum.dennouncedPost,
              postsController.post,
            );

            Get.toNamed(Routes.postDennounce);
          },
        );
      },
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
        child: Padding(
          padding: EdgeInsets.all(8.0.h),
          child: Icon(
            color: AppColors.warning,
            Icons.warning_amber,
            size: 16.0.h,
          ),
        ),
      ),
    );
  }
}
