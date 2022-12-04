import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/home/widgets/filters_type.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/warning_widget.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopBar(),
        FiltersType(),
        FilterResultCount(),
        WarningBanner(
          showBannerCondition: !tiutiuUserController.tiutiuUser.emailVerified,
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          margin: EdgeInsets.only(
            right: Dimensions.getDimensBasedOnDeviceHeight(
              greaterDeviceHeightDouble: 4.0.w,
              minDeviceHeightDouble: 8.5.w,
            ),
            left: Dimensions.getDimensBasedOnDeviceHeight(
              greaterDeviceHeightDouble: 4.0.w,
              minDeviceHeightDouble: 4.0.w,
            ),
            bottom: 8.0.h,
            top: 0.0.h,
          ),
          replacement: SizedBox.shrink(),
        )
      ],
    );
  }
}
