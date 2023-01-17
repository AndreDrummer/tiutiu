import 'package:tiutiu/core/pets/model/pet_model.dart';

enum LikeEnum {
  ownerId,
  post,
  uid,
}

class Like {
  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      ownerId: map[LikeEnum.ownerId.name] as String,
      post: map[LikeEnum.post.name],
      uid: map[LikeEnum.uid.name],
    );
  }

  Like({
    required this.ownerId,
    required this.post,
    required this.uid,
  });
  String ownerId;
  String uid;
  Pet post;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      LikeEnum.uid.name: post.toMap(),
      LikeEnum.ownerId.name: ownerId,
      LikeEnum.post.name: uid,
    };
  }

  @override
  String toString() => 'Like(ownerId: $ownerId, uid: $uid, post: $post)';

  @override
  bool operator ==(covariant Like other) {
    if (identical(this, other)) return true;

    return other.ownerId == ownerId && other.uid == uid && other.post == post;
  }

  @override
  int get hashCode => ownerId.hashCode ^ uid.hashCode ^ post.hashCode;
}
