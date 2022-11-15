import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/core/widgets/verify_account_warning.dart';
import 'package:tiutiu/features/pets/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/home/widgets/filters_type.dart';
import 'package:tiutiu/Widgets/top_bar.dart';
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
        VerifyAccountWarningBanner(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          margin: EdgeInsets.only(
            right: Dimensions.getDimensByPlatform(iosDimen: 4.0.w, androidDimen: 8.5.w),
            left: Dimensions.getDimensByPlatform(iosDimen: 4.0.w, androidDimen: 4.0.w),
            bottom: 8.0.h,
            top: 8.0.h,
          ),
          child: SizedBox.shrink(),
        )
      ],
    );
  }
}
