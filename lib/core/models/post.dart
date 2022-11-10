import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/models/mapper.dart';
import 'package:uuid/uuid.dart';

enum PostEnum {
  describedAddress,
  interesteds,
  description,
  createdAt,
  longitude,
  latitude,
  ownerId,
  hidden,
  photos,
  video,
  owner,
  done,
  state,
  views,
  name,
  type,
  city,
  uid,
}

class Post implements Mapper {
  Post({
    this.describedAddress = '',
    this.city = 'Acrelândia',
    this.photos = const [],
    this.description = '',
    this.interesteds = 0,
    this.state = 'Acre',
    this.hidden = false,
    this.done = false,
    this.type = '-',
    this.views = 0,
    this.longitude,
    this.createdAt,
    this.latitude,
    this.ownerId,
    this.owner,
    this.video,
    this.name,
    this.uid,
  });

  @override
  Post fromMap(Map<String, dynamic> map) {
    return Post(
      uid: map[PostEnum.uid.name] != null ? map[PostEnum.uid.name] : Uuid().v4(),
      createdAt: map[PostEnum.createdAt.name] ?? DateTime.now().toIso8601String(),
      describedAddress: map[PostEnum.describedAddress.name] ?? '',
      owner: TiutiuUser.fromMap(map[PostEnum.owner.name]),
      description: map[PostEnum.description.name] ?? '',
      city: map[PostEnum.city.name] ?? 'Acrelândia',
      interesteds: map[PostEnum.interesteds.name],
      state: map[PostEnum.state.name] ?? 'Acre',
      longitude: map[PostEnum.longitude.name],
      latitude: map[PostEnum.latitude.name],
      type: map[PostEnum.type.name] ?? '-',
      ownerId: map[PostEnum.ownerId.name],
      views: map[PostEnum.views.name] ?? 0,
      photos: map[PostEnum.photos.name],
      hidden: map[PostEnum.hidden.name],
      video: map[PostEnum.video.name],
      name: map[PostEnum.name.name],
      done: map[PostEnum.done.name],
    );
  }

  String describedAddress;
  String description;
  String? createdAt;
  TiutiuUser? owner;
  double? longitude;
  double? latitude;
  String? ownerId;
  int interesteds;
  dynamic video;
  String state;
  String? name;
  bool? hidden;
  List photos;
  String type;
  String city;
  String? uid;
  bool done;
  int views;

  @override
  Map<String, dynamic> toMap({bool convertFileToVideoPath = false}) {
    return {
      PostEnum.photos.name: convertFileToVideoPath ? photos.map((e) => e.path).toList() : photos,
      PostEnum.video.name: convertFileToVideoPath ? video.path : video,
      PostEnum.describedAddress.name: describedAddress,
      PostEnum.interesteds.name: interesteds,
      PostEnum.description.name: description,
      PostEnum.owner.name: owner?.toMap(),
      PostEnum.longitude.name: longitude,
      PostEnum.createdAt.name: createdAt,
      PostEnum.latitude.name: latitude,
      PostEnum.ownerId.name: ownerId,
      PostEnum.hidden.name: hidden,
      PostEnum.state.name: state,
      PostEnum.views.name: views,
      PostEnum.type.name: type,
      PostEnum.name.name: name,
      PostEnum.city.name: city,
      PostEnum.done.name: done,
      PostEnum.uid.name: uid,
    };
  }

  @override
  String toString() {
    return 'Post(createdAt: $createdAt, owner: $owner, longitude: $longitude, latitude: $latitude, ownerId: $ownerId, interesteds: $interesteds, description: $description, state: $state, photos: $photos, name: $name, type: $type, city: $city, uid: $uid, views: $views, video: $video, hidden: $hidden, done: $done)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.describedAddress == describedAddress &&
        other.description == description &&
        other.interesteds == interesteds &&
        other.createdAt == createdAt &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        other.ownerId == ownerId &&
        other.photos == photos &&
        other.hidden == hidden &&
        other.video == video &&
        other.state == state &&
        other.owner == owner &&
        other.views == views &&
        other.name == name &&
        other.done == done &&
        other.type == type &&
        other.city == city &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return describedAddress.hashCode ^
        interesteds.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        ownerId.hashCode ^
        photos.hashCode ^
        hidden.hashCode ^
        owner.hashCode ^
        video.hashCode ^
        views.hashCode ^
        state.hashCode ^
        name.hashCode ^
        done.hashCode ^
        type.hashCode ^
        city.hashCode ^
        uid.hashCode;
  }
}
