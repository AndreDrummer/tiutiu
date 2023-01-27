import 'package:tiutiu/features/tiutiutok/widgets/text_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ViewsCountWidget extends StatelessWidget {
  const ViewsCountWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(FontAwesomeIcons.eye, size: 32.0, color: AppColors.whiteIce),
        ),
        StreamBuilder<int>(
          stream: postsController.postViews(post.uid!),
          builder: (context, snapshot) {
            int views = snapshot.data ?? post.likes;

            return TextButtonCount(
              padding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
              fontSize: 12.0.sp,
              text: '$views',
            );
          },
        ),
        SizedBox(height: 8.0.h),
      ],
    );
  }
}
