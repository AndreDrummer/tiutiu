import 'package:tiutiu/features/saveds/widgets/post_is_saved_stream.dart';
import 'package:tiutiu/features/tiutiutok/widgets/text_buttons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return PostIsSavedStream(
      post: post,
      builder: (icon, isSaved) {
        return InkWell(
          onTap: () {
            if (authController.userExists) {
              if (isSaved) {
                savedsController.unsave(post);
              } else {
                savedsController.save(post);
              }
            } else {
              homeController.setMoreIndex();
            }
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.bookmark, size: 24.0.h, color: isSaved ? AppColors.pink : AppColors.whiteIce),
              ),
              StreamBuilder<int>(
                stream: savedsController.postSavedCount(post.uid!),
                builder: (context, snapshot) {
                  int savedNumber = snapshot.data ?? post.saved;
                  savedNumber = savedNumber > 0 ? savedNumber : 0;

                  return TextButtonCount(
                    padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                    text: '$savedNumber',
                  );
                },
              ),
              SizedBox(height: 16.0.h),
            ],
          ),
        );
      },
    );
  }
}
