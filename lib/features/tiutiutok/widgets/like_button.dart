import 'package:tiutiu/features/tiutiutok/widgets/text_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: likesController.postIsLiked(post),
      builder: (context, snapshot) {
        final liked = snapshot.data ?? false;

        return InkWell(
          onTap: () {
            likesController.like(post, wasLiked: liked);
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(FontAwesomeIcons.solidHeart, color: liked ? AppColors.pink : AppColors.whiteIce),
              ),
              StreamBuilder<int>(
                stream: likesController.postLikes(post.uid!),
                builder: (context, snapshot) {
                  int likesNumber = snapshot.data ?? post.likes;
                  likesNumber = likesNumber > 0 ? likesNumber : 0;

                  return TextButtonCount(
                    padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                    text: '$likesNumber',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
