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

        return Visibility(
          visible: visibile,
          child: StreamBuilder<bool>(
              stream: savedsController.postIsSaved(post),
              builder: (context, snapshot) {
                final isActive = snapshot.data ?? false;

                return InkWell(
                  child: Icon(
                    color: isActive ? AppColors.secondary : Colors.grey[400],
                    size: 21.0.h,
                    Icons.bookmark,
                  ),
                  onTap: isActive ? unsave : save,
                );
              }),
        );
      },
    );
  }

  void unsave() => savedsController.unsave(post);
  void save() => savedsController.save(post);
}
