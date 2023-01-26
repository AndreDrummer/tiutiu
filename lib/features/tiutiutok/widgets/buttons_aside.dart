import 'package:get/get.dart';
import 'package:tiutiu/features/tiutiutok/widgets/whatsapp_share_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/disappeared_alert.dart';
import 'package:tiutiu/features/tiutiutok/widgets/go_to_post_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/views_count_widget.dart';
import 'package:tiutiu/features/tiutiutok/widgets/save_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/like_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

class ButtonsAside extends StatefulWidget {
  const ButtonsAside({super.key, required this.post});

  final Post post;

  @override
  State<ButtonsAside> createState() => _ButtonsAsideState();
}

class _ButtonsAsideState extends State<ButtonsAside> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 64.0.h,
      left: Get.width * .9,
      child: Column(
        children: [
          DisappearedAlertAnimation(post: widget.post),
          ViewsCountWidget(post: widget.post),
          LikeButton(post: widget.post),
          SaveButton(post: widget.post),
          WhatsAppShareButton(post: widget.post),
          GoToPostButton(post: widget.post),
        ],
      ),
    );
  }
}
