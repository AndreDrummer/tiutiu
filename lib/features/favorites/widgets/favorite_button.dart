import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRemoveFavorite extends StatelessWidget {
  const AddRemoveFavorite({
    this.showAlwaysAsFavorited = false,
    this.isRemoveButton = false,
    required this.show,
    required this.post,
    this.tiny = false,
  });
  final bool showAlwaysAsFavorited;
  final bool isRemoveButton;
  final bool show;
  final bool tiny;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final visibile = show && authController.userExists && systemController.properties.internetConnected;

        return Visibility(
          visible: visibile,
          child: StreamBuilder<bool>(
            stream: favoritesController.postIsFavorited(post),
            builder: (context, snapshot) {
              final isActive = showAlwaysAsFavorited || (snapshot.data ?? false);

              final icon = isRemoveButton
                  ? Icons.delete
                  : isActive
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart;

              return GestureDetector(
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    child: Icon(
                      color: isRemoveButton ? AppColors.danger : AppColors.primary,
                      size: tiny ? 16.0.h : 24.0.h,
                      icon,
                    ),
                    padding: EdgeInsets.all(8.0.h),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
                  elevation: 8.0,
                ),
                onTap: (isActive || isRemoveButton) ? removeFavorite : addFavorite,
              );
            },
          ),
        );
      },
    );
  }

  void removeFavorite() => favoritesController.removeFavorite(post);
  void addFavorite() => favoritesController.addFavorite(post);
}
