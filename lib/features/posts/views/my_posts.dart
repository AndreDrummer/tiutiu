import 'package:tiutiu/features/pets/widgets/render_post_list.dart';
import 'package:tiutiu/Widgets/toggle_posts_card_appearence.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
import 'package:tiutiu/Widgets/empty_list.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(
        text: MyProfileOptionsTile.myPosts,
        actions: [
          TogglePostCardAppearence(
            color: AppColors.white,
          ),
        ],
      ),
      body: Obx(() {
        return StreamBuilder<List<Post>>(
          stream: postsController.getMyPosts(),
          builder: (context, snapshot) {
            return AsyncHandler<List<Post>>(
              snapshot: snapshot,
              buildWidget: (posts) {
                return ListView.builder(
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
                      showFavoriteButton: false,
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
