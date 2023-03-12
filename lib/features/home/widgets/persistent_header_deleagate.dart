import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';

import 'filters_type.dart';

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {

  PersistentHeaderDelegate({required this.heigthExtent});
  
  final double heigthExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
         FiltersType(),
          Obx(() => FilterResultCount(postsCount: postsController.postsCount))
        ],
      ),
    );
  }

  @override
  double get maxExtent => heigthExtent;

  @override
  double get minExtent => heigthExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
