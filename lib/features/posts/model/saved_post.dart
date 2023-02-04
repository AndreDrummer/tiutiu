import 'package:tiutiu/features/posts/utils/post_utils.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SavedPostEnum { reference, uid }

class SavedPost {
  SavedPost({
    required this.reference,
    required this.uid,
  });

  factory SavedPost.fromMap(Map<String, dynamic> map) {
    return SavedPost(
      reference: map[SavedPostEnum.reference.name],
      uid: map[SavedPostEnum.uid.name],
    );
  }

  factory SavedPost.fromPost(Post post) {
    return SavedPost(
      reference: PostUtils.updatePostReferenceAndReturn(post.uid!),
      uid: post.uid!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SavedPostEnum.reference.name: reference,
      SavedPostEnum.uid.name: uid,
    };
  }

  DocumentReference reference;
  String uid;

  @override
  String toString() {
    return 'Reference: $reference, Uid: $uid';
  }
}
