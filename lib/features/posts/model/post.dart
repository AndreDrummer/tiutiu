import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/system/model/system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiutiu/core/models/mapper.dart';
import 'package:uuid/uuid.dart';

enum PostEnum {
  describedAddress,
  dennounceMotives,
  timesDennounced,
  sharedTimes,
  description,
  reference,
  createdAt,
  longitude,
  latitude,
  ownerId,
  country,
  hidden,
  photos,
  video,
  owner,
  done,
  state,
  views,
  name,
  likes,
  saved,
  type,
  city,
  uid,
}

class Post implements Mapper {
  Post({
    this.dennounceMotives = const [],
    this.country = defaultCountry,
    this.describedAddress = '',
    this.timesDennounced = 0,
    this.city = 'Acrelândia',
    this.photos = const [],
    this.description = '',
    this.sharedTimes = 0,
    this.state = 'Acre',
    this.hidden = false,
    this.done = false,
    this.type = '-',
    this.views = 0,
    this.reference,
    this.longitude,
    this.createdAt,
    this.saved = 0,
    this.likes = 0,
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
      dennounceMotives: map[PostEnum.dennounceMotives.name] ?? [],
      country: map[PostEnum.country.name] ?? defaultCountry,
      timesDennounced: map[PostEnum.timesDennounced.name],
      owner: TiutiuUser.fromMap(map[PostEnum.owner.name]),
      sharedTimes: map[PostEnum.sharedTimes.name] ?? 0,
      description: map[PostEnum.description.name] ?? '',
      city: map[PostEnum.city.name] ?? 'Acrelândia',
      state: map[PostEnum.state.name] ?? 'Acre',
      reference: map[PostEnum.reference.name],
      longitude: map[PostEnum.longitude.name],
      latitude: map[PostEnum.latitude.name],
      type: map[PostEnum.type.name] ?? '-',
      ownerId: map[PostEnum.ownerId.name],
      likes: map[PostEnum.likes.name] ?? 0,
      saved: map[PostEnum.saved.name] ?? 0,
      views: map[PostEnum.views.name] ?? 0,
      photos: map[PostEnum.photos.name],
      hidden: map[PostEnum.hidden.name],
      video: map[PostEnum.video.name],
      name: map[PostEnum.name.name],
      done: map[PostEnum.done.name],
    );
  }

  DocumentReference? reference;
  String describedAddress;
  List dennounceMotives;
  int timesDennounced;
  String description;
  String? createdAt;
  TiutiuUser? owner;
  double? longitude;
  double? latitude;
  int sharedTimes;
  String? ownerId;
  String country;
  dynamic video;
  String state;
  String? name;
  bool? hidden;
  List photos;
  String type;
  String city;
  String? uid;
  bool done;
  int saved;
  int views;
  int likes;

  @override
  Map<String, dynamic> toMap({bool convertFileToVideoPath = false}) {
    return {
      PostEnum.photos.name: convertFileToVideoPath ? photos.map((e) => e.path).toList() : photos,
      PostEnum.reference.name: reference != null ? reference.toString() : null,
      PostEnum.video.name: convertFileToVideoPath ? video.path : video,
      PostEnum.dennounceMotives.name: dennounceMotives,
      PostEnum.describedAddress.name: describedAddress,
      PostEnum.timesDennounced.name: timesDennounced,
      PostEnum.description.name: description,
      PostEnum.sharedTimes.name: sharedTimes,
      PostEnum.owner.name: owner?.toMap(),
      PostEnum.longitude.name: longitude,
      PostEnum.createdAt.name: createdAt,
      PostEnum.latitude.name: latitude,
      PostEnum.country.name: country,
      PostEnum.ownerId.name: ownerId,
      PostEnum.hidden.name: hidden,
      PostEnum.state.name: state,
      PostEnum.views.name: views,
      PostEnum.likes.name: likes,
      PostEnum.saved.name: saved,
      PostEnum.type.name: type,
      PostEnum.name.name: name,
      PostEnum.city.name: city,
      PostEnum.done.name: done,
      PostEnum.uid.name: uid,
    };
  }

  bool get isValid {
    return photos.isNotEmpty &&
        description.isNotEmpty &&
        ownerId != null &&
        ownerId!.isNotEmpty &&
        latitude != null &&
        longitude != null &&
        name != null &&
        name!.isNotEmpty;
  }

  @override
  String toString() {
    return 'Post(createdAt: $createdAt, saved: $saved, country: $country, owner: $owner, sharedTimes: $sharedTimes, reference: $reference, longitude: $longitude, latitude: $latitude, ownerId: $ownerId, timesDennounced: $timesDennounced, description: $description, state: $state, photos: $photos, name: $name, type: $type, city: $city, uid: $uid, views: $views, video: $video, hidden: $hidden, likes: $likes, done: $done, dennounceMotives: $dennounceMotives)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.describedAddress == describedAddress &&
        other.dennounceMotives == dennounceMotives &&
        other.timesDennounced == timesDennounced &&
        other.description == description &&
        other.sharedTimes == sharedTimes &&
        other.createdAt == createdAt &&
        other.reference == reference &&
        other.longitude == longitude &&
        other.latitude == latitude &&
        other.ownerId == ownerId &&
        other.country == country &&
        other.photos == photos &&
        other.hidden == hidden &&
        other.saved == saved &&
        other.video == video &&
        other.state == state &&
        other.owner == owner &&
        other.views == views &&
        other.likes == likes &&
        other.name == name &&
        other.done == done &&
        other.type == type &&
        other.city == city &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return describedAddress.hashCode ^
        dennounceMotives.hashCode ^
        timesDennounced.hashCode ^
        description.hashCode ^
        sharedTimes.hashCode ^
        createdAt.hashCode ^
        reference.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        country.hashCode ^
        ownerId.hashCode ^
        photos.hashCode ^
        hidden.hashCode ^
        owner.hashCode ^
        video.hashCode ^
        saved.hashCode ^
        views.hashCode ^
        state.hashCode ^
        name.hashCode ^
        likes.hashCode ^
        done.hashCode ^
        type.hashCode ^
        city.hashCode ^
        uid.hashCode;
  }
}
