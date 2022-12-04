import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';
import 'package:tiutiu/core/widgets/toggle_posts_card_appearence.dart';
import 'package:tiutiu/features/posts/widgets/render_post_list.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: DefaultBasicAppBar(
          leading: BackButton(onPressed: postsController.closeMypostsLists),
          text: MyProfileOptionsTile.myPosts,
          actions: [
            TogglePostCardAppearence(
              color: AppColors.white,
            ),
          ],
        ),
        body: RenderPostList(
          itemCount: postsController.filteredPosts.length + 1,
          firstChild: FilterResultCount(isInMyPosts: true),
          posts: postsController.filteredPosts,
        ),
      ),
    );
  }
}
