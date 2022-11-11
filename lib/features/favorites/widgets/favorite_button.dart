import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddFavoriteButton extends StatelessWidget {
  const AddFavoriteButton({
    this.active = false,
    this.onTap,
    super.key,
  });

  final Function()? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) => _AddRemoveFavorite(active: active, onTap: onTap);
}

class RemoveFavoriteButton extends StatelessWidget {
  const RemoveFavoriteButton({super.key, this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) => _AddRemoveFavorite(onTap: onTap, isRemoveButton: true);
}

class _AddRemoveFavorite extends StatelessWidget {
  const _AddRemoveFavorite({
    this.isRemoveButton = false,
    this.active = false,
    this.onTap,
  });

  final bool isRemoveButton;
  final Function()? onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final icon = isRemoveButton
        ? Icons.delete
        : active
            ? Icons.favorite
            : Icons.favorite_border;

    return GestureDetector(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          child: Icon(color: isRemoveButton ? AppColors.danger : AppColors.primary, size: 16.0.h, icon),
          padding: EdgeInsets.all(8.0.h),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0.h)),
        elevation: 2.0,
      ),
      onTap: onTap,
    );
  }
}
