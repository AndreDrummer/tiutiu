import 'package:tiutiu/core/widgets/toggle_posts_card_appearence.dart';
import 'package:tiutiu/features/posts/widgets/render_post_item.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(
        automaticallyImplyLeading: true,
        text: AppStrings.favorites,
        actions: [
          TogglePostCardAppearence(
            color: AppColors.white,
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: favoritesController.favoritesList(),
        builder: (context, snapshot) {
          return AsyncHandler<List<Post>>(
            emptyMessage: AppStrings.noPostFavorited,
            buildWidget: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: ((context, index) {
                  return RenderListItem(post: posts[index], showFavoriteButton: true);
                }),
              );
            },
            snapshot: snapshot,
          );
        },
      ),
    );
  }
}
