import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/dennounce/model/dennounce.dart';
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

class PostDennounce extends Dennounce {
  factory PostDennounce.fromSnapshot(DocumentSnapshot snapshot) {
    final map = snapshot.data() as Map<String, dynamic>;
    final post = Pet().fromMap(map);

    return PostDennounce(
      dennouncer: TiutiuUser.fromMap(snapshot.get(PostDennounceEnum.dennouncer.name)),
      description: snapshot.get(PostDennounceEnum.description.name),
      motive: snapshot.get(PostDennounceEnum.motive.name),
      dennouncedPost: post,
      uid: snapshot.id,
    );
  }

  factory PostDennounce.fromMap(Map<String, dynamic> map) {
    return PostDennounce(
      dennouncedPost: getPostDennounced(map[PostDennounceEnum.dennouncedPost.name]),
      dennouncer: getUserDennouncer(map[PostDennounceEnum.dennouncer.name]),
      description: map[PostDennounceEnum.description.name],
      motive: map[PostDennounceEnum.motive.name],
      uid: map[PostDennounceEnum.uid.name],
    );
  }

  PostDennounce({
    required super.dennouncer,
    this.dennouncedPost,
    super.description,
    super.motive,
    super.uid,
  });

  Post? dennouncedPost;

  @override
  PostDennounce copyWith({
    TiutiuUser? dennouncer,
    Post? dennouncedPost,
    String? description,
    String? motive,
    String? uid,
  }) {
    return PostDennounce(
      dennouncedPost: dennouncedPost ?? this.dennouncedPost,
      description: description ?? this.description,
      dennouncer: dennouncer ?? this.dennouncer,
      motive: motive ?? this.motive,
      uid: uid ?? this.uid,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      PostDennounceEnum.dennouncedPost.name: dennouncedPost?.toMap(),
      PostDennounceEnum.dennouncer.name: dennouncer.toMap(),
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
