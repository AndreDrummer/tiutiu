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
    print(map[PostDennounceEnum.dennouncer.name]);
    return PostDennounce(
      dennouncedPost: getPostDennounced(map[PostDennounceEnum.dennouncedPost.name]),
      dennouncer: getUserDennouncer(map[PostDennounceEnum.dennouncer.name]),
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
  Post? dennouncedPost;
  String? description;
  String? motive;
  String? uid;

  PostDennounce copyWith({
    TiutiuUser? dennouncer,
    Post? dennouncedPost,
    String? description,
    String? motive,
    String? uid,
  }) {
    return PostDennounce(
      dennouncedPost: dennouncedPost ?? dennouncedPost,
      description: description ?? description,
      dennouncer: dennouncer ?? dennouncer,
      motive: motive ?? motive,
      uid: uid ?? uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      PostDennounceEnum.dennouncedPost.name: dennouncedPost?.toMap(),
      PostDennounceEnum.dennouncer.name: dennouncer?.toMap(),
      PostDennounceEnum.description.name: description,
      PostDennounceEnum.motive.name: motive,
      PostDennounceEnum.uid.name: uid,
    };
  }

  static TiutiuUser getUserDennouncer(data) {
    if (data is Map<String, dynamic>) {
      return TiutiuUser.fromMap(data);
    }

    return data;
  }

  static Pet getPostDennounced(data) {
    if (data is Map<String, dynamic>) {
      return Pet().fromMap(data);
    }

    return data;
  }

  @override
  String toString() {
    return 'description: $description, dennouncer: $dennouncer, motive: $motive, dennouncedPost: $dennouncedPost, uid: $uid';
  }
}
