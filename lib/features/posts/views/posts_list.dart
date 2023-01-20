import 'package:tiutiu/features/posts/widgets/render_post_list.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/mixins/tiu_tiu_pop_up.dart';
import 'package:tiutiu/features/posts/model/post.dart';
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
    return FutureBuilder<List<Post>>(
      future: postsController.getAllPosts(),
      builder: (context, snapshot) {
        return AsyncHandler<List<Post>>(
          forcedDataReturned: snapshot.data ?? [],
          forceReturnBuildWidget: true,
          buildWidget: (_) {
            return Obx(
              () {
                final posts = postsController.filteredPosts;

                return RefreshIndicator(
                  onRefresh: () async => postsController.getAllPosts(),
                  child: Padding(
                    padding: EdgeInsets.only(left: posts.isEmpty ? Get.width / 4.5 : 0.0),
                    child: RenderPostList(itemCount: posts.length + 1, posts: posts),
                  ),
                );
              },
            );
          },
          snapshot: snapshot,
        );
      },
    );
  }
}
