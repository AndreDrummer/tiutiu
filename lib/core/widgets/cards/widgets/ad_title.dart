import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/formatter.dart';
import 'package:flutter/material.dart';

class AdTitle extends StatelessWidget {
  const AdTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final isCardVisibility = homeController.cardVisibilityKind == CardVisibilityKind.card;

    return Container(
      margin: EdgeInsets.only(bottom: 2.0.h),
      child: AutoSizeTexts.autoSizeText14(
        color: isCardVisibility ? AppColors.white : Colors.black,
        Formatters.cuttedText(title, size: 20),
        textOverflow: TextOverflow.fade,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
