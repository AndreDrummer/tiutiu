import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddRemoveFavorite extends StatelessWidget {
  const AddRemoveFavorite({
    this.isRemoveButton = false,
    this.active = false,
    this.onRemove,
    this.onAdd,
  });

  final Function()? onRemove;
  final bool isRemoveButton;
  final Function()? onAdd;
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
      onTap: (active || isRemoveButton) ? onRemove : onAdd,
    );
  }
}
