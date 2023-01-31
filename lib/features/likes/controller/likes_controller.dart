import 'package:tiutiu/core/local_storage/local_storage_keys.dart';
import 'package:tiutiu/features/likes/services/likes_service.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/core/local_storage/local_storage.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:async';

class LikesController extends GetxController {
  LikesController({
    required LikesService likesService,
    required PostService postsServices,
  })  : _likesService = likesService,
        _postsService = postsServices;

  final LikesService _likesService;
  final PostService _postsService;

  StreamController<List> _postLikedUnloggedIds = StreamController.broadcast();

  List postLikedUnloggedIdsList = [];

  Stream<List> get postLikedUnloggedIds => _postLikedUnloggedIds.stream;

  @override
  void onClose() {
    _syncUnloggedLikesStreamWithLocalStorage();
  }

  Future<void> getLikesSavedOnDevice() async {
    postLikedUnloggedIdsList.clear();

    postLikedUnloggedIdsList = await LocalStorage.getValueUnderLocalStorageKey(LocalStorageKey.unloggedLikesMap);
    _postLikedUnloggedIds.sink.add(postLikedUnloggedIdsList);
  }

  Future<void> _syncUnloggedLikesStreamWithLocalStorage() async {
    final lastStreammeadList = await _postLikedUnloggedIds.stream.last;
    await LocalStorage.setValueUnderLocalStorageKey(key: LocalStorageKey.unloggedLikesMap, value: lastStreammeadList);
    _postLikedUnloggedIds.close();
  }

  Future<void> like(Post post) async {
    if (kDebugMode) debugPrint('TiuTiuApp: Post liked');
    _incrementLikes(post.uid!);
    _saveLikeOnLocal(post.uid!);

    if (authController.userExists) {
      _likesService.likedsCollection().doc(post.uid).set(post.toMap());
    }
  }

  Future<void> unlike(Post post) async {
    if (kDebugMode) debugPrint('TiuTiuApp: Post unliked');
    if (authController.userExists) {
      await _likesService.likedsCollection().doc(post.uid).delete();
    }

    if (post.likes > 0) _decrementLikes(post.uid!);
    _unSaveLikeOnLocal(post.uid!);
  }

  void _saveLikeOnLocal(String postId) {
    if (!postLikedUnloggedIdsList.contains(postId)) {
      postLikedUnloggedIdsList.add(postId);
      _postLikedUnloggedIds.sink.add(postLikedUnloggedIdsList);
    }
  }

  Future<void> _unSaveLikeOnLocal(String postId) async {
    if (postLikedUnloggedIdsList.contains(postId)) {
      postLikedUnloggedIdsList.remove(postId);
      _postLikedUnloggedIds.sink.add(postLikedUnloggedIdsList);
    }
  }

  void _incrementLikes(String postId) {
    _postsService.pathToPost(postId).set({PostEnum.likes.name: FieldValue.increment(1)}, SetOptions(merge: true));
  }

  void _decrementLikes(String postId) {
    _postsService.pathToPost(postId).set({PostEnum.likes.name: FieldValue.increment(-1)}, SetOptions(merge: true));
  }

  Stream<bool> postIsLikedStream(Post post) {
    return _likesService
        .likedsCollection()
        .snapshots()
        .asyncMap((event) => event.docs.firstWhereOrNull((e) => e.get(PostEnum.uid.name) == post.uid) != null);
  }

  Stream<int> postLikesCount(String postId) {
    return _postsService.pathToPost(postId).snapshots().asyncMap((snapshot) {
      final map = snapshot.data() as Map<String, dynamic>;
      return Pet().fromMap(map).likes;
    });
  }
}
