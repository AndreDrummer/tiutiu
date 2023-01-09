import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/posts/widgets/render_post_list.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
          text: AppStrings.favorites,
        ),
        body: Obx(
          () => StreamBuilder<List<Post>>(
            stream: favoritesController.favoritesList(filterController.getParams),
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
        floatingActionButton: ChangePostsVisibilityFloatingButtom(),
      ),
    );
  }
}
