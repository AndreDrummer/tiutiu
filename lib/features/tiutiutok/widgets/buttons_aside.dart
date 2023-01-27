import 'package:tiutiu/features/tiutiutok/widgets/whatsapp_share_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/views_count_widget.dart';
import 'package:tiutiu/features/tiutiutok/widgets/disappeared_alert.dart';
import 'package:tiutiu/features/tiutiutok/widgets/save_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/like_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      bottom: 96.0.h,
      left: distanceFromBorderRight((widget.post as Pet).disappeared),
      child: Column(
        children: [
          DisappearedAlertAnimation(post: widget.post),
          ViewsCountWidget(post: widget.post),
          LikeButton(post: widget.post),
          SaveButton(post: widget.post),
          WhatsAppShareButton(post: widget.post),
        ],
      ),
    );
  }

  double distanceFromBorderRight(bool isDisappeared) {
    final deviceHeight = Get.height;
    if (isDisappeared) {
      if (deviceHeight > 999)
        return Get.width * .9;
      else if (deviceHeight < 700) return Get.width * .85;
      return Get.width * .8;
    } else {
      if (deviceHeight > 999)
        return Get.width * .95;
      else if (deviceHeight < 700) return Get.width * .86;
      return Get.width * .85;
    }
  }
}
