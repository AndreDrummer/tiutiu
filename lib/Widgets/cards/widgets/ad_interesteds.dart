import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/firebase_env_path.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AdInteresteds extends StatelessWidget {
  const AdInteresteds({
    required this.petKind,
    this.visible = false,
    super.key,
  });

  final String petKind;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0.h),
        child: Row(
          children: [
            Icon(Icons.favorite, size: 12.0.h, color: Colors.grey[400]),
            Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: AutoSizeText(
                '15 ${petKind == FirebaseEnvPath.donate ? '${AppStrings.interesteds}' : '${AppStrings.infos}'}',
                style: TextStyles.fontSize12(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
