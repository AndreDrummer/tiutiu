import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/remove_question.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:tiutiu/core/utils/pickers.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AvatarProfile extends StatefulWidget {
  const AvatarProfile({
    this.viewOnly = false,
    this.onAssetRemoved,
    this.onAssetPicked,
    this.avatarPath,
    this.radius,
    this.hero,
    super.key,
  });

  final void Function(File?)? onAssetPicked;
  final void Function()? onAssetRemoved;
  final dynamic avatarPath;
  final double? radius;
  final bool viewOnly;
  final Object? hero;

  @override
  State<AvatarProfile> createState() => _AvatarProfileState();
}

class _AvatarProfileState extends State<AvatarProfile> with Pickers {
  bool isEditingImage = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.viewOnly
          ? null
          : () {
              if (widget.avatarPath != null) {
                setState(() {
                  isEditingImage = true;
                });
              } else {
                pickAnAsset(
                  onAssetPicked: (file) => widget.onAssetPicked?.call(file),
                  pickerAssetType: PickerAssetType.photo,
                  context: context,
                );
              }
            },
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: widget.radius ?? 40.0.h,
              child: ClipOval(
                child: AssetHandle.getImage(
                  widget.avatarPath,
                  isUserImage: true,
                  hero: widget.hero,
                ),
              ),
            ),
            Visibility(
              visible: isEditingImage,
              child: _avatarProfileBlur(
                onRemove: () {
                  setState(() {
                    isEditingImage = false;
                    widget.onAssetRemoved?.call();
                  });
                },
                onClose: () {
                  setState(() {
                    isEditingImage = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  CircleAvatar _avatarProfileBlur({
    required void Function() onClose,
    void Function()? onRemove,
  }) {
    return CircleAvatar(
      backgroundColor: AppColors.black.withAlpha(190),
      radius: widget.radius ?? 40.0.h,
      child: RemoveQuestion(
        spaceBetweenLines: 16.0.h,
        spaceBetweenIcons: 0.0.w,
        onRemove: onRemove,
        onClose: onClose,
        fontSize: 16,
      ),
    );
  }
}
