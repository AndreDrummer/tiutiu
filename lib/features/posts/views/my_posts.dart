import 'package:tiutiu/core/widgets/toggle_posts_card_appearence.dart';
import 'package:tiutiu/features/posts/widgets/render_post_list.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/empty_list.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/dimensions.dart';
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
                      showFavoriteButton: false,
                      onItemTapped: () {
                        postsController.isEditingPost = true;
                        postsController.post = posts[index];
                        Get.offNamed(Routes.petDetails);
                      },
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
