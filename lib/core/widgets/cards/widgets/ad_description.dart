import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AdDescription extends StatelessWidget {
  const AdDescription({
    required this.maxFontSize,
    required this.description,
    super.key,
  });

  final String description;
  final double maxFontSize;

  @override
  Widget build(BuildContext context) {
    final isCardVisibility = homeController.cardVisibilityKind == CardVisibilityKind.card;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: AutoSizeText(
        maxFontSize: maxFontSize,
        minFontSize: 8,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: isCardVisibility ? AppColors.white : Colors.grey[700],
        ),
        description,
      ),
    );
  }
}
