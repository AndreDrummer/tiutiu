import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/core/models/filter_params.dart';
import 'package:flutter/foundation.dart';

final DISAPPEARED_TAB = 1;

class PostsRepository {
  PostsRepository({required PostService postService})
      : _postService = postService;

  final PostService _postService;

  Future<List<Pet>> getPostList(FilterParams filterParams) async {
    debugPrint('>>Cache getPostList');
    List<Pet> petsList = [];

    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;
    final todaysCache = await LocalStorage.getValueUnderStringKey(today);

    if (todaysCache != null) {
      debugPrint('>>Cache exists');
      petsList = await _getPostsFromCache();
      // petsList = await _getPostFromInternet(filterParams);
    } else {
      debugPrint('>>Cache is null');
      debugPrint('>>downloading from Internet...');
      petsList = await _getPostFromInternet(filterParams);
    }

    return petsList;
  }

  Future<List<Pet>> _getPostsFromCache() async {
    debugPrint('>>Cache getPostsFromCache');
    final postsCached = await _cachedPostsMap();

    debugPrint('>>Cached Posts Map $postsCached');

    return List<Pet>.from(
      postsCached.values.map(
        (post) {
          print('Post $post');
          return Pet().fromMap(post);
        },
      ).toList(),
    );
  }

  Future<List<Pet>> _getPostFromInternet(FilterParams filterParams) async {
    debugPrint('>>Cache _getPostFromInternet');
    final postData = await _postService.loadPets(filterParams);

    var postsList = List<Pet>.from(postData.map((post) => Pet().fromMap(post)));
    _cachePosts(posts: postsList);
    return postsList;
  }

  Future<void> _cachePosts({required List<Pet> posts}) async {
    final Map<String, dynamic> postsToCache = {};
    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    debugPrint('>>Cache _cachePost');

    posts.forEach((post) async {
      postsToCache.putIfAbsent(post.uid!, () => post.toMap());
    });

    debugPrint('>>Cache current saved post map $postsToCache');

    await LocalStorage.setValueUnderStringKey(
      value: postsToCache,
      key: today,
    );

    final afterSavedMap = await LocalStorage.getValueUnderStringKey(today);

    debugPrint('>>Cache After Saved Map $afterSavedMap');
  }

  Future<Map<String, dynamic>> _cachedPostsMap() async {
    final Map<String, dynamic> cachedPostsMap = {};
    var today = DateTime.now().toIso8601String();
    today = today.split('T').first;

    final storagedPosts = await LocalStorage.getValueUnderStringKey(today);

    if (storagedPosts != null) {
      cachedPostsMap.addAll(storagedPosts);
    }

    debugPrint('>>Storaged Posts $cachedPostsMap');

    return cachedPostsMap;
  }

  Future<void> uploadVideo({
    required Function(String?) onUploaded,
    required Pet post,
  }) async {
    await _postService.uploadVideo(
      onVideoUploaded: onUploaded,
      post: post,
    );
  }

  Future<void> uploadImages({
    required Function(List) onUploaded,
    required Pet post,
  }) async {
    await _postService.uploadImages(
      onImagesUploaded: onUploaded,
      post: post,
    );
  }

  Future<void> uploadPostData({required Pet post}) async {
    await _postService.uploadPostData(post);
  }
}
