import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/features/dennounce/model/dennounce.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserDennounceEnum {
  dennouncedUser,
  description,
  dennouncer,
  motive,
  uid,
}

class UserDennounce extends Dennounce {
  factory UserDennounce.fromSnapshot(DocumentSnapshot snapshot) {
    return UserDennounce(
      dennouncedUser: TiutiuUser.fromMap(snapshot.get(UserDennounceEnum.dennouncedUser.name)),
      dennouncer: TiutiuUser.fromMap(snapshot.get(UserDennounceEnum.dennouncer.name)),
      description: snapshot.get(UserDennounceEnum.description.name),
      motive: snapshot.get(UserDennounceEnum.motive.name),
      uid: snapshot.id,
    );
  }

  factory UserDennounce.fromMap(Map<String, dynamic> map) {
    return UserDennounce(
      dennouncedUser: getUserDennouncer(map[UserDennounceEnum.dennouncedUser.name]),
      dennouncer: getUserDennouncer(map[UserDennounceEnum.dennouncer.name]),
      description: map[UserDennounceEnum.description.name],
      motive: map[UserDennounceEnum.motive.name],
      uid: map[UserDennounceEnum.uid.name],
    );
  }

  UserDennounce({
    required super.dennouncer,
    this.dennouncedUser,
    super.description,
    super.motive,
    super.uid,
  });

  TiutiuUser? dennouncedUser;

  @override
  UserDennounce copyWith({
    TiutiuUser? dennouncedUser,
    TiutiuUser? dennouncer,
    String? description,
    String? motive,
    String? uid,
  }) {
    return UserDennounce(
      dennouncedUser: dennouncedUser ?? this.dennouncedUser,
      description: description ?? this.description,
      dennouncer: dennouncer ?? this.dennouncer,
      motive: motive ?? this.motive,
      uid: uid ?? this.uid,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      UserDennounceEnum.dennouncedUser.name: dennouncedUser?.toMap(),
      UserDennounceEnum.dennouncer.name: dennouncer.toMap(),
      UserDennounceEnum.description.name: description,
      UserDennounceEnum.motive.name: motive,
      UserDennounceEnum.uid.name: uid,
    };
  }

  static TiutiuUser getUserDennouncer(data) {
    if (data is Map<String, dynamic>) {
      return TiutiuUser.fromMap(data);
    }

    return data;
  }

  static Pet getUserDennounced(data) {
    if (data is Map<String, dynamic>) {
      return Pet().fromMap(data);
    }

    return data;
  }

  @override
  String toString() {
    return 'description: $description, dennouncer: $dennouncer, motive: $motive, dennouncedUser: $dennouncedUser, uid: $uid';
  }
}
