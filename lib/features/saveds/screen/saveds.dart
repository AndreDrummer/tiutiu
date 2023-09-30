import 'package:tiutiu/core/widgets/change_posts_visibility_floating_button.dart';
import 'package:tiutiu/features/posts/widgets/render_post_item.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/model/saved_post.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/widgets/empty_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          text: AppLocalizations.of(context)!.saveds,
        ),
        body: Obx(
          () => StreamBuilder<List<SavedPost>>(
            stream: savedsController.savedsList(),
            builder: (context, snapshot) {
              final savedPosts = snapshot.data ?? [];

              if (savedPosts.isEmpty) return EmptyListScreen(showClearFiltersButton: false);

              return ListView.builder(
                itemCount: savedPosts.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<Post?>(
                    stream: savedsController.postFromReference(savedPosts[index].reference),
                    builder: (context, snapshot) {
                      return AsyncHandler<Post>(
                        loadingWidget: Center(child: LinearProgressIndicator()),
                        emptyWidget: SizedBox.shrink(),
                        buildWidget: (post) {
                          return RenderListItem(
                            onNavigateToTop: () => homeController.onScrollUp(),
                            showBackToStartButton: false,
                            showSaveButton: true,
                            key: Key(post.uid!),
                            post: post,
                          );
                        },
                        snapshot: snapshot,
                      );
                    },
                  );
                },
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
