import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        VerifyAccountWarning(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
          margin: EdgeInsets.symmetric(horizontal: 4.0.w),
          child: SizedBox.shrink(),
        )
      ],
    );
  }
}
