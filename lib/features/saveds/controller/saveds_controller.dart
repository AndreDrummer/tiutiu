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

class SavedsController extends GetxController {
  final RxList<Post> _savedPosts = <Post>[].obs;

  List<Post> get savedPosts => _savedPosts;

  void save(Post post) {
    debugPrint('TiuTiuApp: Add to saves');
    _savesCollection().doc(post.uid).set(post.toMap());

    // TODO: INC POST SAVEDS
  }

  void unsave(Post post) {
    debugPrint('TiuTiuApp: Remove from saves');
    _savesCollection().doc(post.uid).delete();
  }

  Stream<List<Post>> savedsList(FilterParams filters) {
    final queryMap = _savesCollection().where(FilterParamsEnum.disappeared.name, isEqualTo: false);
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
    return _savesCollection()
        .snapshots()
        .asyncMap((event) => event.docs.firstWhereOrNull((e) => e.get(PostEnum.uid.name) == post.uid) != null);
  }

  CollectionReference<Map<String, dynamic>> _savesCollection() {
    return EndpointResolver.getCollectionEndpoint(
      EndpointNames.pathToSaveds.name,
      [tiutiuUserController.tiutiuUser.uid],
    );
  }
}
