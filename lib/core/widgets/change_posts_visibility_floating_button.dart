import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePostsVisibilityFloatingButtom extends StatelessWidget {
  const ChangePostsVisibilityFloatingButtom({super.key, this.visibility = true});

  final bool visibility;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isCardVisibility = postsController.cardVisibilityKind == CardVisibilityKind.card;
        final isToCloseApp = systemController.isToCloseApp;

        return Visibility(
          visible: !isToCloseApp && visibility,
          child: FloatingActionButton(
            child: Icon(isCardVisibility ? Icons.list_outlined : Icons.photo_outlined),
            tooltip: AppLocalizations.of(context)!.changeListVisual,
            onPressed: () {
              postsController.changeCardVisibilityKind();
            },
          ),
        );
      },
    );
  }
}
