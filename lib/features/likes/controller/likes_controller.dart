import 'package:tiutiu/core/constants/endpoints_name.dart';
import 'package:tiutiu/core/utils/endpoint_resolver.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LikesController extends GetxController {
  final RxList<Post> _LikedPosts = <Post>[].obs;

  List<Post> get LikedPosts => _LikedPosts;

  void like(Post post) {
    debugPrint('TiuTiuApp: Post liked');
    if (authController.userExists) {
      _likedsCollection().doc(post.uid).set(post.toMap());
    }

    // TODO: INC POST LIKES
  }

  void unlike(Post post) {
    debugPrint('TiuTiuApp: Post unliked');
    _likedsCollection().doc(post.uid).delete();
  }

  Stream<bool> postIsLiked(Post post) {
    if (tiutiuUserController.tiutiuUser.uid == null) return Stream.value(false);
    return _likedsCollection()
        .snapshots()
        .asyncMap((event) => event.docs.firstWhereOrNull((e) => e.get(PostEnum.uid.name) == post.uid) != null);
  }

  CollectionReference<Map<String, dynamic>> _likedsCollection() {
    return EndpointResolver.getCollectionEndpoint(
      EndpointNames.pathToLikes.name,
      [tiutiuUserController.tiutiuUser.uid],
    );
  }
}
