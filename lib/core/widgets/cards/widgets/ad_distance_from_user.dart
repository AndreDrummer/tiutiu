import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AdDistanceFromUser extends StatelessWidget {
  const AdDistanceFromUser({
    required this.distanceText,
    super.key,
  });

  final String distanceText;

  @override
  Widget build(BuildContext context) {
    final isCardVisibility = homeController.cardVisibilityKind == CardVisibilityKind.card;
    return Padding(
      padding: EdgeInsets.only(bottom: 0.0.h),
      child: Row(
        children: [
          AutoSizeTexts.autoSizeText10(
            color: isCardVisibility ? AppColors.white : Colors.grey[700],
            textOverflow: TextOverflow.fade,
            'Está a $distanceText de você',
            fontWeight: FontWeight.w700,
          ),
          SizedBox(width: 2.0.w),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0.h),
            child: Icon(
              color: isCardVisibility ? AppColors.white : Colors.grey[700],
              FontAwesomeIcons.locationDot,
              size: 7.0.h,
            ),
          )
        ],
      ),
    );
  }
}
