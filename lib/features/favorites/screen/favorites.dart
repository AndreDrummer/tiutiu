import 'package:tiutiu/features/pets/widgets/render_post_list.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/widgets/async_handler.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/models/post.dart';
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
        text: AppStrings.favorites,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<Post>>(
        stream: favoritesController.favoritesList(),
        builder: (context, snapshot) {
          return AsyncHandler<List<Post>>(
            buildWidget: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: ((context, index) {
                  return RenderListItem(
                    onNavigateToTop: () => homeController.onScrollUp(),
                    post: posts[index],
                  );
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
