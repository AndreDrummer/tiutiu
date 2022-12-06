import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TogglePostCardAppearence extends StatelessWidget {
  const TogglePostCardAppearence({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        homeController.changeCardVisibilityKind();
      },
      icon: Obx(
        () => Icon(
          color: color ?? AppColors.primary,
          homeController.cardVisibilityKind == CardVisibilityKind.card ? Icons.view_list_outlined : Icons.view_agenda,
        ),
      ),
    );
  }
}
