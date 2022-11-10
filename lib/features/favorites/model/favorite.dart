import 'package:tiutiu/features/pets/model/pet_model.dart';

enum FavoriteEnum {
  ownerId,
  post,
  uid,
}

class Favorite {
  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      ownerId: map[FavoriteEnum.ownerId.name] as String,
      post: map[FavoriteEnum.post.name],
      uid: map[FavoriteEnum.uid.name],
    );
  }

  Favorite({
    required this.ownerId,
    required this.post,
    required this.uid,
  });
  String ownerId;
  String uid;
  Pet post;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FavoriteEnum.uid.name: post.toMap(),
      FavoriteEnum.ownerId.name: ownerId,
      FavoriteEnum.post.name: uid,
    };
  }

  @override
  String toString() => 'Favorite(ownerId: $ownerId, uid: $uid, post: $post)';

  @override
  bool operator ==(covariant Favorite other) {
    if (identical(this, other)) return true;

    return other.ownerId == ownerId && other.uid == uid && other.post == post;
  }

  @override
  int get hashCode => ownerId.hashCode ^ uid.hashCode ^ post.hashCode;
}
