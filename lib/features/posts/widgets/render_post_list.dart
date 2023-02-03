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
    this.isInMyPosts = false,
    required this.itemCount,
    required this.posts,
    super.key,
  });

  final Widget firstChild;
  final bool isInMyPosts;
  final List<Post> posts;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        firstChild,
        Visibility(
          visible: posts.isNotEmpty,
          replacement: Padding(
            padding: EdgeInsets.only(top: Get.width / 4, left: 24.0.w),
            child: EmptyListScreen(),
          ),
          child: Expanded(
            child: ListView.builder(
              itemCount: itemCount,
              padding: EdgeInsets.only(
                right: Dimensions.getDimensBasedOnDeviceHeight(
                  smaller: 5.0.w,
                  medium: 5.0.w,
                  bigger: 0.0.w,
                ),
              ),
              key: UniqueKey(),
              itemBuilder: (_, index) {
                int postIndex = index < posts.length ? index : posts.length - 1;
                return RenderListItem(
                  showBackToStartButton: index == posts.length && !isInMyPosts,
                  onNavigateToTop: () => homeController.onScrollUp(),
                  key: Key(posts[postIndex].uid.toString()),
                  showSaveButton: !isInMyPosts,
                  post: posts[postIndex],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
