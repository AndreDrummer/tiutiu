import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:flutter/foundation.dart';

final DISAPPEARED_TAB = 1;

class PostsRepository {
  PostsRepository({required PostService postService})
      : _postService = postService;

  final PostService _postService;

  Future<List<Pet>> getPostList() async {
    if (kDebugMode) debugPrint('TiuTiuApp: Cache getPostList');
    List<Pet> petsList = [];

    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    final todaysCache = await LocalStorage.getValueUnderStringKey(today);

    if (todaysCache != null && !systemController.properties.internetConnected) {
      if (kDebugMode) debugPrint('TiuTiuApp: Cache exists');
      petsList = await _getPostsFromCache();
    } else {
      if (kDebugMode) debugPrint('TiuTiuApp: downloading from Internet...');
      petsList = await _getPostFromInternet();
    }

    return petsList;
  }

  Future<List<Pet>> _getPostsFromCache() async {
    if (kDebugMode) debugPrint('TiuTiuApp: Cache getPostsFromCache');
    final postsCached = await _cachedPostsMap();

    if (kDebugMode) debugPrint('TiuTiuApp: Cached Posts Map $postsCached');

    return List<Pet>.from(
      postsCached.values.map((post) => Pet().fromMap(post)).toList(),
    );
  }

  Future<List<Pet>> _getPostFromInternet() async {
    try {
      if (kDebugMode) debugPrint('TiuTiuApp: Cache _getPostFromInternet');
      final postData = await _postService.loadPosts();

      if (kDebugMode) debugPrint('TiuTiuApp: Posts Loaded from Internet');
      var postsList = List<Pet>.from(postData.docs.map((post) {
        final map = post.data();

        if (map[PostEnum.uid.name] != null) return Pet().fromMap(map);
        return Pet();
      })).where((element) => element.uid != null).toList();
      _cachePosts(posts: postsList);

      // if (kDebugMode) debugPrint('TiuTiuApp: Posts List $postsList');
      return postsList;
    } catch (exception) {
      crashlyticsController.reportAnError(
        message: 'Something went wrong when trying loadPosts $exception',
        stackTrace: StackTrace.current,
        exception: exception,
      );
      return [];
    }
  }

  Future<void> _cachePosts({required List<Pet> posts}) async {
    final Map<String, dynamic> postsToCache = {};
    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    if (kDebugMode) debugPrint('TiuTiuApp: Cache _cachePost');

    posts.forEach((post) async {
      postsToCache.putIfAbsent(post.uid!, () => post.toMap());
    });

    if (kDebugMode)
      // debugPrint('TiuTiuApp: Cache current saved post map $postsToCache');

      await LocalStorage.setValueUnderStringKey(
        value: postsToCache,
        key: today,
      );

    await LocalStorage.getValueUnderStringKey(today);
    // final afterSavedMap = await LocalStorage.getValueUnderStringKey(today);

    // if (kDebugMode) debugPrint('TiuTiuApp: Cache After Saved Map $afterSavedMap');
  }

  Future<Map<String, dynamic>> _cachedPostsMap() async {
    final Map<String, dynamic> cachedPostsMap = {};
    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    final storagedPosts = await LocalStorage.getValueUnderStringKey(today);

    if (storagedPosts != null) {
      cachedPostsMap.addAll(storagedPosts);
    }

    if (kDebugMode) debugPrint('TiuTiuApp: Storaged Posts $cachedPostsMap');

    return cachedPostsMap;
  }

  Future<void> uploadVideo(
      {required Function(String?) onUploaded, required Post post}) async {
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

  Future<void> updatePostReference({required Post post}) async {
    await _postService.updatePostReference(post);
  }

  Future<void> deletePost({required Post post}) async {
    await _postService.deletePost(post);
  }
}
