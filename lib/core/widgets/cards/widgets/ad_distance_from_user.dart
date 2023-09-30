import 'package:tiutiu/features/posts/controller/posts_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdDistanceFromUser extends StatelessWidget {
  const AdDistanceFromUser({
    required this.distanceText,
    super.key,
  });

  final String distanceText;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isBannerCardVisibilityKind = postsController.cardVisibilityKind == CardVisibilityKind.banner;
      return Visibility(
        visible: !systemController.properties.accessLocationDenied,
        child: Padding(
          padding: EdgeInsets.only(top: isBannerCardVisibilityKind ? 4.0.h : 0.0.h),
          child: Row(
            children: [
              AutoSizeTexts.autoSizeText10(
                color: Colors.grey[700],
                textOverflow: TextOverflow.fade,
                AppLocalizations.of(context)!.isFromYou(distanceText),
                fontWeight: FontWeight.w700,
              ),
              SizedBox(width: 2.0.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.0.h),
                child: Icon(
                  FontAwesomeIcons.locationDot,
                  color: Colors.grey[700],
                  size: 7.0.h,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
