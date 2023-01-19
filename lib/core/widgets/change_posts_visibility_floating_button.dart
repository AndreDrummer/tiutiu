import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePostsVisibilityFloatingButtom extends StatelessWidget {
  const ChangePostsVisibilityFloatingButtom({super.key, this.visibility = true});

  final bool visibility;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: Obx(
        () {
          final isCardVisibility = postsController.cardVisibilityKind == CardVisibilityKind.card;

          return FloatingActionButton(
            child: Icon(isCardVisibility ? Icons.menu : Icons.photo),
            tooltip: AppStrings.changeListVisual,
            onPressed: () {
              postsController.changeCardVisibilityKind();
            },
          );
        },
      ),
    );
  }
}
