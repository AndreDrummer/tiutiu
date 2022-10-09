import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'dart:convert';

enum PostEnum {
  disappeared,
  interesteds,
  description,
  imagesPath,
  completed,
  videoPath,
  ownerId,
  hidden,
  title,
  owner,
  views,
  uuid,
  city,
  uf,
}

class Post {
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      disappeared: map[PostEnum.disappeared.name],
      interesteds: map[PostEnum.interesteds.name],
      description: map[PostEnum.description.name],
      imagesPath: map[PostEnum.imagesPath.name],
      completed: map[PostEnum.completed.name],
      videoPath: map[PostEnum.videoPath.name],
      ownerId: map[PostEnum.ownerId.name],
      hidden: map[PostEnum.hidden.name],
      title: map[PostEnum.title.name],
      owner: map[PostEnum.owner.name],
      views: map[PostEnum.views.name],
      uuid: map[PostEnum.uuid.name],
      city: map[PostEnum.city.name] ?? 'Todas',
      uf: map[PostEnum.uf.name] ?? 'Todos',
    );
  }

  Post({
    this.city = 'Todas',
    this.uf = 'Todos',
    this.description,
    this.interesteds,
    this.disappeared,
    this.imagesPath,
    this.videoPath,
    this.completed,
    this.ownerId,
    this.hidden,
    this.title,
    this.views,
    this.owner,
    this.uuid,
  });

  String? description;
  dynamic videoPath;
  TiutiuUser? owner;
  bool? disappeared;
  List? imagesPath;
  int? interesteds;
  String? ownerId;
  bool? completed;
  String? hidden;
  String? title;
  String city;
  String? uuid;
  int? views;
  String uf;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      PostEnum.description.name: description,
      PostEnum.disappeared.name: disappeared,
      PostEnum.interesteds.name: interesteds,
      PostEnum.imagesPath.name: imagesPath,
      PostEnum.owner.name: owner?.toMap(),
      PostEnum.completed.name: completed,
      PostEnum.videoPath.name: videoPath,
      PostEnum.ownerId.name: ownerId,
      PostEnum.hidden.name: hidden,
      PostEnum.title.name: title,
      PostEnum.views.name: views,
      PostEnum.city.name: city,
      PostEnum.uuid.name: uuid,
      PostEnum.uf.name: uf,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Post(description: $description, videoPath: $videoPath, owner: $owner, disappeared: $disappeared, imagesPath: $imagesPath, interesteds: $interesteds, ownerId: $ownerId, completed: $completed, hidden: $hidden, title: $title, city: $city, uuid: $uuid, views: $views, uf: $uf)';
  }
}
