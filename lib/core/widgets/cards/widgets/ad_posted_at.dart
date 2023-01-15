import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';

class AdPostedAt extends StatelessWidget {
  const AdPostedAt({
    super.key,
    required this.createdAt,
  });

  final String createdAt;

  @override
  Widget build(BuildContext context) {
    final isCardVisibility = homeController.cardVisibilityKind == CardVisibilityKind.card;

    return SizedBox(
      height: 16.0.h,
      child: AutoSizeTexts.autoSizeText10(
        '${AppStrings.postedAt} ${Formatters.getFormattedDate(createdAt)}',
        color: isCardVisibility ? AppColors.white : Colors.grey[700],
        fontWeight: FontWeight.w700,
        textAlign: TextAlign.left,
      ),
    );
  }
}
