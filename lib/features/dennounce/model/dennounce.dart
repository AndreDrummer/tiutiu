import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum DennounceEnum {
  description,
  dennouncer,
  motive,
  uid,
}

class Dennounce {
  factory Dennounce.fromSnapshot(DocumentSnapshot snapshot) {
    return Dennounce(
      dennouncer: TiutiuUser.fromMap(snapshot.get(DennounceEnum.dennouncer.name)),
      description: snapshot.get(DennounceEnum.description.name),
      motive: snapshot.get(DennounceEnum.motive.name),
      uid: snapshot.id,
    );
  }

  factory Dennounce.fromMap(Map<String, dynamic> map) {
    return Dennounce(
      dennouncer: getUserDennouncer(map[DennounceEnum.dennouncer.name]),
      description: map[DennounceEnum.description.name],
      motive: map[DennounceEnum.motive.name],
      uid: map[DennounceEnum.uid.name],
    );
  }

  Dennounce({
    required this.dennouncer,
    this.description = '',
    this.motive = '',
    this.uid = '',
  });

  TiutiuUser dennouncer;
  String description;
  String motive;
  String uid;

  Dennounce copyWith({
    TiutiuUser? dennouncer,
    String? description,
    String? motive,
    String? uid,
  }) {
    return Dennounce(
      description: description ?? this.description,
      dennouncer: dennouncer ?? this.dennouncer,
      motive: motive ?? this.motive,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DennounceEnum.dennouncer.name: dennouncer.toMap(),
      DennounceEnum.description.name: description,
      DennounceEnum.motive.name: motive,
      DennounceEnum.uid.name: uid,
    };
  }

  static TiutiuUser getUserDennouncer(data) {
    if (data is Map<String, dynamic>) {
      return TiutiuUser.fromMap(data);
    }

    return data;
  }

  @override
  String toString() {
    return 'description: $description, dennouncer: $dennouncer, motive: $motive, uid: $uid';
  }
}
