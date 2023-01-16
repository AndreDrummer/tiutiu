import 'package:tiutiu/features/favorites/widgets/post_is_saved_stream.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveOrUnsave extends StatelessWidget {
  const SaveOrUnsave({
    required this.show,
    required this.post,
    this.tiny = false,
  });

  final bool show;
  final bool tiny;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final visibile = show && authController.userExists && systemController.properties.internetConnected;
        final isCardVisibility = homeController.cardVisibilityKind == CardVisibilityKind.card;

        return Visibility(
          visible: visibile,
          child: PostIsSavedStream(
            post: post,
            builder: (icon, isActive) => GestureDetector(
              child: Padding(
                child: Icon(
                  color: isCardVisibility ? AppColors.white : AppColors.primary,
                  size: isCardVisibility ? 32.0.h : 20.0.h,
                  icon,
                ),
                padding: EdgeInsets.all(8.0.h),
              ),
              onTap: isActive ? unsave : save,
            ),
          ),
        );
      },
    );
  }

  void unsave() => savedsController.unsave(post);
  void save() => savedsController.save(post);
}
