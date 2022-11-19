import 'package:tiutiu/features/posts/widgets/render_post_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/empty_list.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenderPostList extends StatelessWidget {
  const RenderPostList({
    this.firstChild = const SizedBox.shrink(),
    required this.itemCount,
    required this.posts,
    super.key,
  });

  final Widget firstChild;
  final List<Post> posts;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        firstChild,
        Expanded(
          child: ListView.builder(
            itemCount: itemCount,
            padding: EdgeInsets.only(
              right: Dimensions.getDimensBasedOnDeviceHeight(
                greaterDeviceHeightDouble: 0.0.w,
                minDeviceHeightDouble: 5.0.w,
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
        ),
      ],
    );
  }
}
