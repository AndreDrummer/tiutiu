import 'package:tiutiu/features/posts/widgets/remove_asset_blur.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AdPicture extends StatefulWidget {
  const AdPicture({
    required this.onPicturedRemoved,
    required this.onAddPicture,
    required this.color,
    this.imagePath,
    super.key,
  });

  final Function() onPicturedRemoved;
  final Function() onAddPicture;
  final dynamic imagePath;
  final Color color;

  @override
  State<AdPicture> createState() => _AdPictureState();
}

class _AdPictureState extends State<AdPicture> {
  bool isEditingImage = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.imagePath != null) {
          setState(() {
            isEditingImage = true;
          });
        } else {
          widget.onAddPicture();
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.h),
            ),
            child: Container(
              height: 140.0.h,
              width: 240.0.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.white.withAlpha(100),
                ),
                borderRadius: BorderRadius.circular(8.0.h),
                color: AppColors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0.h),
                child: image(),
              ),
            ),
          ),
          Visibility(
            visible: isEditingImage,
            child: RemoveAssetBlur(
              onClose: () {
                setState(() {
                  isEditingImage = false;
                });
              },
              onRemove: () {
                widget.onPicturedRemoved();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget image() {
    var imagePath = widget.imagePath;
    if (imagePath != null) {
      return imagePath.toString().contains('http')
          ? Image.network(
              imagePath,
              fit: BoxFit.cover,
            )
          : imagePath.runtimeType == String
              ? Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  imagePath,
                  fit: BoxFit.cover,
                );
    }
    return Padding(
      padding: EdgeInsets.all(32.0.h),
      child: Icon(
        Icons.add_a_photo_outlined,
        color: Colors.grey,
        size: 40.0.h,
      ),
    );
  }
}
