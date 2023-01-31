import 'package:tiutiu/features/saveds/services/saved_services.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SavedsController extends GetxController {
  SavedsController({
    required SavedServices savedServices,
    required PostService postsServices,
  })  : _savedServices = savedServices,
        _postsService = postsServices;

  final SavedServices _savedServices;
  final PostService _postsService;

  final RxList<Post> _savedPosts = <Post>[].obs;
  List<Post> get savedPosts => _savedPosts;

  void save(Post post) {
    if (kDebugMode) debugPrint('TiuTiuApp: Add to saves');
    _savedServices.savesCollection().doc(post.uid).set(post.toMap());

    _incrementSavedTimes(post.uid!);
  }

  void unsave(Post post) {
    if (kDebugMode) debugPrint('TiuTiuApp: Remove from saves');
    _savedServices.savesCollection().doc(post.uid).delete();
    if (post.saved > 0) _decrementSavedTimes(post.uid!);
  }

  Stream<List<Post>> savedsList() {
    final queryMap = _savedServices.savesCollection();
    List<Post> savedPosts = [];

    return queryMap.snapshots().asyncMap((event) {
      savedPosts.clear();
      event.docs.forEach((save) {
        if (save.data().isNotEmpty) {
          final map = save.data();
          final pet = Pet().fromMap(map);

          savedPosts.add(pet);
        }
      });

      _savedPosts(savedPosts);

      return PostUtils.filteredByRules(savedPosts);
    });
  }

  Stream<bool> postIsSaved(Post post) {
    if (tiutiuUserController.tiutiuUser.uid == null) return Stream.value(false);
    return _savedServices
        .savesCollection()
        .snapshots()
        .asyncMap((event) => event.docs.firstWhereOrNull((e) => e.get(PostEnum.uid.name) == post.uid) != null);
  }

  void _incrementSavedTimes(String postId) {
    _postsService.pathToPost(postId).set({PostEnum.saved.name: FieldValue.increment(1)}, SetOptions(merge: true));
  }

  void _decrementSavedTimes(String postId) {
    _postsService.pathToPost(postId).set({PostEnum.saved.name: FieldValue.increment(-1)}, SetOptions(merge: true));
  }

  Stream<int> postSavedCount(String postId) {
    return _postsService.pathToPost(postId).snapshots().asyncMap((snapshot) {
      final map = snapshot.data() as Map<String, dynamic>;
      return Pet().fromMap(map).saved;
    });
  }
}
