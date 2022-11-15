import 'package:tiutiu/features/pets/widgets/render_post_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DonateList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _PostsList();
}

class FinderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _PostsList();
}

class _PostsList extends StatelessWidget with TiuTiuPopUp {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final posts = postsController.filteredPosts;

      return RefreshIndicator(
        onRefresh: () async => postsController.loadPosts(getFromInternet: true),
        child: ListView.builder(
          itemCount: (posts.length + 1),
          padding: EdgeInsets.only(
            right: Dimensions.getDimensBasedOnDeviceHeight(
              minDeviceHeightDouble: 5.0.w,
              greaterDeviceHeightDouble: 0.0.w,
            ),
          ),
          key: UniqueKey(),
          itemBuilder: (_, index) {
            if (posts.isEmpty)
              return Padding(
                padding: EdgeInsets.only(top: Get.width / 2),
                child: EmptyListScreen(),
              );

            return RenderListItem(
              post: posts[index < posts.length ? index : posts.length - 1],
              onNavigateToTop: () => homeController.onScrollUp(),
              showBackToStartButton: index == posts.length,
            );
          },
        ),
      );
    });
  }
}
