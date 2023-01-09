import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class ChangePostsVisibilityFloatingButtom extends StatelessWidget {
  const ChangePostsVisibilityFloatingButtom({super.key, this.visibility = true});

  final bool visibility;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: FloatingActionButton(
        child: Icon(
          homeController.cardVisibilityKind == CardVisibilityKind.card ? Icons.view_list_outlined : Icons.view_agenda,
        ),
        tooltip: AppStrings.changeListVisual,
        onPressed: () {
          homeController.changeCardVisibilityKind();
        },
      ),
    );
  }
}
