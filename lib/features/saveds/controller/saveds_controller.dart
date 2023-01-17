import 'package:tiutiu/features/saveds/services/saved_services.dart';
import 'package:tiutiu/features/posts/services/post_service.dart';
import 'package:tiutiu/features/posts/model/filter_params.dart';
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

  void save(Post post, {bool wasSaved = false}) {
    if (wasSaved) {
      unsave(post);
    } else {
      debugPrint('TiuTiuApp: Add to saves');
      _savedServices.savesCollection().doc(post.uid).set(post.toMap());

      _incrementSavedTimes(post.uid!);
    }
  }

  void unsave(Post post) {
    debugPrint('TiuTiuApp: Remove from saves');
    _savedServices.savesCollection().doc(post.uid).delete();
    _decrementSavedTimes(post.uid!);
  }

  Stream<List<Post>> savedsList(FilterParams filters) {
    final queryMap = _savedServices.savesCollection().where(FilterParamsEnum.disappeared.name, isEqualTo: false);
    List<Post> savedPosts = [];

    return queryMap.snapshots().asyncMap((event) {
      savedPosts.clear();
      event.docs.forEach((save) {
        if (save.data().isNotEmpty) {
          savedPosts.add(Pet.fromSnapshot(save));
        }
      });

      _savedPosts(savedPosts);

      return PostUtils.filterPosts(postsList: savedPosts);
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
}
