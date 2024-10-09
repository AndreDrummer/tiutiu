import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostOverlay extends StatelessWidget {
  const PostOverlay({super.key, this.post});

  final Post? post;

  @override
  Widget build(BuildContext context) {
    bool postPhotosAreEmptyOrNull = false;

    if (post == null || post!.photos.isEmpty) {
      postPhotosAreEmptyOrNull = true;
    }

    return Visibility(
      visible: post != null && !postPhotosAreEmptyOrNull,
      child: GestureDetector(
        onTap: () {
          if (post != null) {
            postsController.post = post!;
            Get.toNamed(Routes.postDetails);
          }
        },
        child: Container(
          width: Get.width,
          color: AppColors.white.withAlpha(180),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: AssetHandle.getImage(
                  postPhotosAreEmptyOrNull ? null : post?.photos[0],
                  fit: BoxFit.cover,
                  isUserImage: false,
                ),
                margin: EdgeInsets.only(right: 4.0.w),
                height: 40.0.h,
                width: 40.0.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 2.0.h),
                  AutoSizeTexts.autoSizeText14(post?.name, fontWeight: FontWeight.bold),
                  SizedBox(height: 1.0.h),
                  AutoSizeTexts.autoSizeText10(
                    '${(post as Pet).breed} | ${(post as Pet).color} | ${(post as Pet).gender}',
                  ),
                ],
              ),
              Spacer(),
              Padding(
                child: AutoSizeTexts.autoSizeText10('${(post as Pet).city} - ${(post as Pet).state}'),
                padding: EdgeInsets.only(top: 26.0.h, right: 8.0.h),
              )
            ],
          ),
        ),
      ),
    );
  }
}
