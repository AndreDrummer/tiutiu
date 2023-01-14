import 'package:tiutiu/features/posts/model/filter_params.dart';
import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final RxList<Post> _favoritedPosts = <Post>[].obs;

  List<Post> get favoritedPosts => _favoritedPosts;

  void addFavorite(Post post) {
    debugPrint('TiuTiuApp: Add to favorites');
    _favoritesCollection().doc(post.uid).set(post.toMap());
  }

  void removeFavorite(Post post) {
    debugPrint('TiuTiuApp: Remove from favorites');
    _favoritesCollection().doc(post.uid).delete();
  }

  Stream<List<Post>> favoritesList(FilterParams filters) {
    final queryMap = _favoritesCollection().where(FilterParamsEnum.disappeared.name, isEqualTo: false);
    List<Post> favoritedPosts = [];

    return queryMap.snapshots().asyncMap((event) {
      favoritedPosts.clear();
      event.docs.forEach((favorite) {
        if (favorite.data().isNotEmpty) {
          favoritedPosts.add(Pet.fromSnapshot(favorite));
        }
      });

      _favoritedPosts(favoritedPosts);

      return PostUtils.filterPosts(postsList: favoritedPosts);
    });
  }

  Stream<bool> postIsFavorited(Post post) {
    if (tiutiuUserController.tiutiuUser.uid == null) return Stream.value(false);
    return _favoritesCollection()
        .snapshots()
        .asyncMap((event) => event.docs.firstWhereOrNull((e) => e.get(PostEnum.uid.name) == post.uid) != null);
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollection() {
    return EndpointResolver.getCollectionEndpoint(
      EndpointNames.pathToFavorites.name,
      [tiutiuUserController.tiutiuUser.uid],
    );
  }
}
