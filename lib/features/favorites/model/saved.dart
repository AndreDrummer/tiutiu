import 'package:tiutiu/core/pets/model/pet_model.dart';

enum SavedEnum {
  ownerId,
  post,
  uid,
}

class Saved {
  factory Saved.fromMap(Map<String, dynamic> map) {
    return Saved(
      ownerId: map[SavedEnum.ownerId.name] as String,
      post: map[SavedEnum.post.name],
      uid: map[SavedEnum.uid.name],
    );
  }

  Saved({
    required this.ownerId,
    required this.post,
    required this.uid,
  });
  String ownerId;
  String uid;
  Pet post;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      SavedEnum.uid.name: post.toMap(),
      SavedEnum.ownerId.name: ownerId,
      SavedEnum.post.name: uid,
    };
  }

  @override
  String toString() => 'Saved(ownerId: $ownerId, uid: $uid, post: $post)';

  @override
  bool operator ==(covariant Saved other) {
    if (identical(this, other)) return true;

    return other.ownerId == ownerId && other.uid == uid && other.post == post;
  }

  @override
  int get hashCode => ownerId.hashCode ^ uid.hashCode ^ post.hashCode;
}
