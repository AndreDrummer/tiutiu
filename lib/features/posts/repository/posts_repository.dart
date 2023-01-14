import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/foundation.dart';

final DISAPPEARED_TAB = 1;

class PostsRepository {
  PostsRepository({required PostService postService}) : _postService = postService;

  final PostService _postService;

  Future<List<Pet>> getPostList() async {
    debugPrint('TiuTiuApp: Cache getPostList');
    List<Pet> petsList = [];

    var yesterday = DateTime.now().subtract(Duration(days: 1)).toIso8601String();
    var today = DateTime.now().toIso8601String();

    yesterday = yesterday.split('T').first;
    today = today.split('T').first;

    final todaysCache = await LocalStorage.getValueUnderStringKey(today);

    if (todaysCache != null && !systemController.properties.internetConnected) {
      await LocalStorage.deleteValueUnderStringKey(yesterday);
      debugPrint('TiuTiuApp: Cache exists');
      petsList = await _getPostsFromCache();
    } else {
      debugPrint('TiuTiuApp: downloading from Internet...');
      petsList = await _getPostFromInternet();
    }

    return petsList;
  }

  Future<List<Pet>> _getPostsFromCache() async {
    debugPrint('TiuTiuApp: Cache getPostsFromCache');
    final postsCached = await _cachedPostsMap();

    debugPrint('TiuTiuApp: Cached Posts Map $postsCached');

    return List<Pet>.from(
      postsCached.values.map((post) => Pet().fromMap(post)).toList(),
    );
  }

  Future<List<Pet>> _getPostFromInternet() async {
    try {
      debugPrint('TiuTiuApp: Cache _getPostFromInternet');
      final postData = await _postService.loadPosts();

      debugPrint('TiuTiuApp: Posts Loaded from Internet');
      var postsList = List<Pet>.from(postData.docs.map((post) => Pet.fromSnapshot(post)));
      _cachePosts(posts: postsList);

      debugPrint('TiuTiuApp: Posts List $postsList');
      return postsList;
    } catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Something went wrong when trying loadPosts $exception',
        exception: exception,
      );
      return [];
    }
  }

  Future<void> _cachePosts({required List<Pet> posts}) async {
    final Map<String, dynamic> postsToCache = {};
    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    debugPrint('TiuTiuApp: Cache _cachePost');

    posts.forEach((post) async {
      postsToCache.putIfAbsent(post.uid!, () => post.toMap());
    });

    debugPrint('TiuTiuApp: Cache current saved post map $postsToCache');

    await LocalStorage.setValueUnderStringKey(
      value: postsToCache,
      key: today,
    );

    final afterSavedMap = await LocalStorage.getValueUnderStringKey(today);

    debugPrint('TiuTiuApp: Cache After Saved Map $afterSavedMap');
  }

  Future<Map<String, dynamic>> _cachedPostsMap() async {
    final Map<String, dynamic> cachedPostsMap = {};
    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    final storagedPosts = await LocalStorage.getValueUnderStringKey(today);

    if (storagedPosts != null) {
      cachedPostsMap.addAll(storagedPosts);
    }

    debugPrint('TiuTiuApp: Storaged Posts $cachedPostsMap');

    return cachedPostsMap;
  }

  Future<void> uploadVideo({required Function(String?) onUploaded, required Post post}) async {
    await _postService.uploadVideo(
      onVideoUploaded: onUploaded,
      post: post,
    );
  }

  Future<void> uploadImages({
    required Function(List) onUploaded,
    required Post post,
    List<String> imagesToDelete = const [],
  }) async {
    await _postService.uploadImages(
      imagesToDelete: imagesToDelete,
      onImagesUploaded: onUploaded,
      post: post,
    );
  }

  Future<void> uploadPostData({required Post post}) async {
    await _postService.uploadPostData(post);
  }

  Future<void> deletePost({required Post post}) async {
    await _postService.deletePost(post);
  }
}
