import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRemoveFavorite extends StatelessWidget {
  const AddRemoveFavorite({
    this.isRemoveButton = false,
    required this.show,
    required this.post,
    this.tiny = false,
  });

  final bool isRemoveButton;
  final bool show;
  final bool tiny;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: show && authController.userExists && systemController.properties.internetConnected,
        child: StreamBuilder<bool>(
          stream: favoritesController.postIsFavorited(post),
          builder: (context, snapshot) {
            final isActive = snapshot.data ?? false;

            final icon = isRemoveButton
                ? Icons.delete
                : isActive
                    ? Icons.favorite
                    : Icons.favorite_border;

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
      ),
    );
  }

  void removeFavorite() => favoritesController.removeFavorite(post);
  void addFavorite() => favoritesController.addFavorite(post);
}
