import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'filters_type.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Visibility(
      visible: homeController.bottomBarIndex == BottomBarIndex.DONATE.indx ||
          homeController.bottomBarIndex == BottomBarIndex.FINDER.indx,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.only(top: 4.0.h),
        child: ListView(
          children: [
            FiltersType(),
            Obx(
              () => Container(
                margin: EdgeInsets.only(top: 4.0.h),
                child: FilterResultCount(postsCount: postsController.postsCount),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final extent = homeController.bottomBarIndex == BottomBarIndex.DONATE.indx ||
          homeController.bottomBarIndex == BottomBarIndex.FINDER.indx
      ? 102.0.h
      : 0.0.h;

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
