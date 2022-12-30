import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PostDennounceEnum {
  dennouncedPost,
  description,
  dennouncer,
  motive,
  uid,
}

class PostDennounce {
  factory PostDennounce.fromSnapshot(DocumentSnapshot snapshot) {
    return PostDennounce(
      dennouncedPost: Pet().fromMap(snapshot.get(PostDennounceEnum.dennouncedPost.name)),
      dennouncer: TiutiuUser.fromMap(snapshot.get(PostDennounceEnum.dennouncer.name)),
      description: snapshot.get(PostDennounceEnum.description.name),
      motive: snapshot.get(PostDennounceEnum.motive.name),
      uid: snapshot.id,
    );
  }

  factory PostDennounce.fromMap(Map<String, dynamic> map) {
    return PostDennounce(
      dennouncer: TiutiuUser.fromMap(map[PostDennounceEnum.dennouncer.name]),
      dennouncedPost: map[PostDennounceEnum.dennouncedPost.name],
      description: map[PostDennounceEnum.description.name],
      motive: map[PostDennounceEnum.motive.name],
      uid: map[PostDennounceEnum.uid.name],
    );
  }

  PostDennounce({
    this.dennouncedPost,
    this.description,
    this.dennouncer,
    this.motive,
    this.uid,
  });

  TiutiuUser? dennouncer;
  String? description;
  Post? dennouncedPost;
  String? motive;
  String? uid;

  Map<String, dynamic> toMap() {
    return {
      PostDennounceEnum.dennouncedPost.name: dennouncedPost,
      PostDennounceEnum.description.name: description,
      PostDennounceEnum.dennouncer.name: dennouncer,
      PostDennounceEnum.motive.name: motive,
      PostDennounceEnum.uid.name: uid,
    };
  }

  @override
  String toString() {
    return 'description: $description, dennouncer: $dennouncer, motive: $motive, dennouncedPost: $dennouncedPost, uid: $uid';
  }
}
