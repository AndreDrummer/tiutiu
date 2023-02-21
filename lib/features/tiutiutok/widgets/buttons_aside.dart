import 'package:tiutiu/features/tiutiutok/widgets/whatsapp_share_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/views_count_widget.dart';
import 'package:tiutiu/features/tiutiutok/widgets/disappeared_alert.dart';
import 'package:tiutiu/features/tiutiutok/widgets/save_button.dart';
import 'package:tiutiu/features/tiutiutok/widgets/like_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonsAside extends StatefulWidget {
  const ButtonsAside({super.key, required this.post});

  final Post post;

  @override
  State<ButtonsAside> createState() => _ButtonsAsideState();
}

class _ButtonsAsideState extends State<ButtonsAside> with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.height < 700 ? 96.0.h : 64.0.h,
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
    if (isDisappeared) {
      return Dimensions.getDimensBasedOnDeviceHeight(
        smaller: Get.width * .85,
        bigger: Get.width * .88,
        xBigger: Get.width * .9,
        medium: Get.width * .8,
      );
    } else {
      return Dimensions.getDimensBasedOnDeviceHeight(
        smaller: Get.width * .86,
        bigger: Get.width * .88,
        xBigger: Get.width * .95,
        medium: Get.width * .85,
      );
    }
  }
}
