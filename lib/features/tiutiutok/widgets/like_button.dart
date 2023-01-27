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
    return Visibility(
      replacement: _UnloggedLikeButton(post: post),
      child: _LoggedLikeButton(post: post),
      visible: authController.userExists,
    );
  }
}

class _LoggedLikeButton extends StatelessWidget {
  const _LoggedLikeButton({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: likesController.postIsLikedStream(post),
      builder: (context, snapshot) {
        final liked = snapshot.data ?? false;

        return InkWell(
          onTap: () {
            if (liked) {
              likesController.unlike(post);
            } else {
              likesController.like(post);
            }
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.solidHeart,
                  size: 32.0,
                  color: liked ? AppColors.pink : AppColors.whiteIce,
                ),
              ),
              StreamBuilder<int>(
                stream: likesController.postLikesCount(post.uid!),
                builder: (context, snapshot) {
                  int likesNumber = snapshot.data ?? post.likes;
                  likesNumber = likesNumber > 0 ? likesNumber : 0;

                  return TextButtonCount(
                    padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                    fontSize: 12.0.sp,
                    text: '$likesNumber',
                  );
                },
              ),
              SizedBox(height: 8.0.h)
            ],
          ),
        );
      },
    );
  }
}

class _UnloggedLikeButton extends StatelessWidget {
  const _UnloggedLikeButton({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: likesController.getLikesSavedOnDevice(),
      builder: (context, snapshot) {
        return StreamBuilder<List>(
          initialData: [],
          stream: likesController.postLikedUnloggedIds,
          builder: (context, snapshot) {
            final likedList = snapshot.data;
            final liked = likedList!.contains(post.uid);

            return InkWell(
              onTap: () {
                if (liked) {
                  likesController.unlike(post);
                } else {
                  likesController.like(post);
                }
              },
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      size: 32.0,
                      color: liked ? AppColors.pink : AppColors.whiteIce,
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: likesController.postLikesCount(post.uid!),
                    builder: (context, snapshot) {
                      int likesNumber = snapshot.data ?? post.likes;
                      likesNumber = likesNumber > 0 ? likesNumber : 0;

                      return TextButtonCount(
                        padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                        fontSize: 12.0.sp,
                        text: '$likesNumber',
                      );
                    },
                  ),
                  SizedBox(height: 8.0.h)
                ],
              ),
            );
          },
        );
      },
    );
  }
}
