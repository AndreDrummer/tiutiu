import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/asset_handle.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostTypeCardSelector extends StatelessWidget {
  const PostTypeCardSelector({
    super.key,
    this.onTypeSelected,
    required this.typeText,
    required this.isSelected,
    required this.image,
  });

  final Function()? onTypeSelected;
  final String typeText;
  final bool isSelected;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTypeSelected,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.all(isSelected ? 0 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0.h),
          border: Border.all(
            color: AppColors.secondary,
            style: BorderStyle.solid,
            width: 2.0.w,
          ),
        ),
        child: _cardSelector(),
      ),
    );
  }

  Card _cardSelector() {
    return Card(
      margin: EdgeInsets.zero,
      color: isSelected ? AppColors.secondary : AppColors.white,
      shadowColor: isSelected ? AppColors.secondary : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.h),
      ),
      elevation: isSelected ? 8.0 : 4.0,
      child: _cardSelectorContent(isSelected),
    );
  }

  Widget _cardSelectorContent(bool isSelected) {
    return SizedBox(
      height: isSelected ? 112.0.h : 100.0.h,
      width: isSelected ? 112.0.h : 100.0.h,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _selectorImage(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0.h),
            child: _selectorTitle(),
          ),
        ],
      ),
    );
  }

  SizedBox _selectorImage() {
    return SizedBox(
      height: isSelected ? 92.0.h : 80.0.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0.h),
        child: AssetHandle.getImage(
          fit: BoxFit.cover,
          image,
        ),
      ),
    );
  }

  AutoSizeText _selectorTitle() {
    return AutoSizeTexts.autoSizeText(
      color: isSelected ? AppColors.white : AppColors.secondary,
      fontSize: Get.height <= 616 ? 14 : 16,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
      typeText,
    );
  }
}
