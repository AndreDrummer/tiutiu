import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/posts/widgets/render_post_list.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Saveds extends StatefulWidget {
  @override
  _SavedsState createState() => _SavedsState();
}

class _SavedsState extends State<Saveds> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        filterController.reset();
        return true;
      },
      child: Scaffold(
        appBar: DefaultBasicAppBar(
          automaticallyImplyLeading: true,
          text: AppStrings.saveds,
        ),
        body: Obx(
          () => StreamBuilder<List<Post>>(
            stream: savedsController.savedsList(filterController.getParams),
            builder: (context, snapshot) {
              final posts = snapshot.data ?? [];

              return RenderPostList(
                firstChild: FilterResultCount(postsCount: posts.length),
                itemCount: posts.length,
                posts: posts,
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Obx(
          () => ChangePostsVisibilityFloatingButtom(visibility: savedsController.savedPosts.isNotEmpty),
        ),
      ),
    );
  }
}
