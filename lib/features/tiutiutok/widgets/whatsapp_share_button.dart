import 'package:tiutiu/features/tiutiutok/widgets/text_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

class WhatsAppShareButton extends StatelessWidget {
  const WhatsAppShareButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        postsController.post = post;
        postsController.sharePost();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 13.0.h,
            backgroundColor: AppColors.primary,
            child: Padding(
              padding: EdgeInsets.only(left: 1.0.w, bottom: 0.5.h),
              child: Icon(FontAwesomeIcons.whatsapp, color: AppColors.white, size: 16.h),
            ),
          ),
          StreamBuilder<int>(
            stream: postsController.postSharedTimes(post.uid!),
            builder: (context, snapshot) {
              int sharedTimesNumber = snapshot.data ?? post.likes;

              return TextButtonCount(
                padding: EdgeInsets.only(left: 0.5.w, top: 6.0.h),
                text: '$sharedTimesNumber',
              );
            },
          ),
          SizedBox(height: 8.0.h),
        ],
      ),
    );
  }
}
