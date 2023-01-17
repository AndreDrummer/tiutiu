import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoToPostButton extends StatelessWidget {
  const GoToPostButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.only(right: 16.0.w)),
      onPressed: () {
        postsController.post = post;
        Get.toNamed(Routes.postDetails);
      },
      child: AutoSizeTexts.autoSizeText14(
        'Ir para post',
        color: AppColors.white,
      ),
    );
  }
}
