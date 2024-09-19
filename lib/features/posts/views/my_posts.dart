import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/posts/widgets/filter_count_order_by.dart';
import 'package:tiutiu/features/posts/widgets/render_post_list.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: true,
        onPopInvokedWithResult: (_, __) async {
          postsController.closeMypostsLists();
        },
        child: Scaffold(
          appBar: DefaultBasicAppBar(
            text: AppLocalizations.of(context)!.myPosts,
            automaticallyImplyLeading: true,
          ),
          body: RenderPostList(
            firstChild: FilterResultCount(
                postsCount: postsController.postsCount, isInMyPosts: true),
            itemCount: postsController.filteredPosts.length,
            posts: postsController.filteredPosts,
            isInMyPosts: true,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: ChangePostsVisibilityFloatingButtom(
            visibility: postsController.filteredPosts.isNotEmpty,
          ),
        ),
      ),
    );
  }
}
