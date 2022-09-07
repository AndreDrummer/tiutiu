import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/extensions/enum_tostring.dart';

enum PetEnum {
  otherCaracteristics,
  donatedOrFound,
  storageHashKey,
  interesteds,
  disappeared,
  longitude,
  createdAt,
  latitude,
  ageMonth,
  details,
  ownerId,
  ageYear,
  photos,
  health,
  gender,
  color,
  state,
  views,
  breed,
  type,
  owner,
  size,
  name,
  kind,
  city,
  uid,
}

class Pet {
  Pet({
    this.donatedOrFound = false,
    this.otherCaracteristics,
    this.interesteds = 0,
    this.storageHashKey,
    this.disappeared,
    this.longitude,
    this.createdAt,
    this.latitude,
    this.ageMonth,
    this.details,
    this.photos,
    this.ageYear,
    this.ownerId,
    this.health,
    this.gender,
    this.color,
    this.views,
    this.breed,
    this.type,
    this.state,
    this.owner,
    this.size,
    this.name,
    this.kind,
    this.city,
    this.uid,
  });

  static Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      otherCaracteristics: map[PetEnum.otherCaracteristics.tostring()],
      donatedOrFound: map[PetEnum.donatedOrFound.tostring()] ?? false,
      owner: TiutiuUser.fromMap(map[PetEnum.owner.tostring()]),
      storageHashKey: map[PetEnum.storageHashKey.tostring()],
      disappeared: map[PetEnum.disappeared.tostring()],
      interesteds: map[PetEnum.interesteds.tostring()],
      longitude: map[PetEnum.longitude.tostring()],
      createdAt: map[PetEnum.createdAt.tostring()],
      latitude: map[PetEnum.latitude.tostring()],
      ageMonth: map[PetEnum.ageMonth.tostring()],
      details: map[PetEnum.details.tostring()],
      ownerId: map[PetEnum.ownerId.tostring()],
      ageYear: map[PetEnum.ageYear.tostring()],
      photos: map[PetEnum.photos.tostring()],
      health: map[PetEnum.health.tostring()],
      gender: map[PetEnum.gender.tostring()],
      color: map[PetEnum.color.tostring()],
      state: map[PetEnum.state.tostring()],
      views: map[PetEnum.views.tostring()],
      breed: map[PetEnum.breed.tostring()],
      type: map[PetEnum.type.tostring()],
      size: map[PetEnum.size.tostring()],
      name: map[PetEnum.name.tostring()],
      kind: map[PetEnum.kind.tostring()],
      city: map[PetEnum.city.tostring()],
      uid: map[PetEnum.uid.tostring()],
    );
  }

  static Pet fromMigrate(Map<String, dynamic> map) {
    return Pet(
      otherCaracteristics: map[PetEnum.otherCaracteristics.tostring()],
      donatedOrFound: map['donated'] ?? map['found'] ?? false,
      storageHashKey: map[PetEnum.storageHashKey.tostring()],
      longitude: map[PetEnum.longitude.tostring()],
      createdAt: map[PetEnum.createdAt.tostring()],
      latitude: map[PetEnum.latitude.tostring()],
      ownerId: map['ownerId'],
      ageMonth: map['meses'],
      details: map[PetEnum.details.tostring()],
      ageYear: map['ano'],
      photos: map[PetEnum.photos.tostring()],
      health: map[PetEnum.health.tostring()],
      gender: map['sex'],
      color: map[PetEnum.color.tostring()],
      views: map[PetEnum.views.tostring()],
      breed: map[PetEnum.breed.tostring()],
      owner: map[PetEnum.owner.tostring()],
      type: map[PetEnum.type.tostring()],
      size: map[PetEnum.size.tostring()],
      name: map[PetEnum.name.tostring()],
      kind: map[PetEnum.kind.tostring()],
      city: map[PetEnum.city.tostring()],
      uid: map[PetEnum.uid.tostring()],
    );
  }

  List? otherCaracteristics;
  String? storageHashKey;
  bool donatedOrFound;
  String? createdAt;
  TiutiuUser? owner;
  bool? disappeared;
  double? longitude;
  double? latitude;
  String? ownerId;
  int interesteds;
  String? details;
  String? gender;
  String? health;
  String? state;
  String? color;
  int? ageMonth;
  String? breed;
  int? ageYear;
  String? size;
  String? type;
  String? kind;
  String? city;
  List? photos;
  String? name;
  String? uid;
  int? views;

  Map<String, dynamic> toMap() {
    return {
      PetEnum.otherCaracteristics.tostring(): otherCaracteristics,
      PetEnum.donatedOrFound.tostring(): donatedOrFound,
      PetEnum.storageHashKey.tostring(): storageHashKey,
      PetEnum.disappeared.tostring(): disappeared,
      PetEnum.interesteds.tostring(): interesteds,
      PetEnum.owner.tostring(): owner?.toMap(),
      PetEnum.longitude.tostring(): longitude,
      PetEnum.createdAt.tostring(): createdAt,
      PetEnum.latitude.tostring(): latitude,
      PetEnum.ageMonth.tostring(): ageMonth,
      PetEnum.details.tostring(): details,
      PetEnum.ownerId.tostring(): ownerId,
      PetEnum.ageYear.tostring(): ageYear,
      PetEnum.photos.tostring(): photos,
      PetEnum.health.tostring(): health,
      PetEnum.gender.tostring(): gender,
      PetEnum.state.tostring(): state,
      PetEnum.color.tostring(): color,
      PetEnum.views.tostring(): views,
      PetEnum.breed.tostring(): breed,
      PetEnum.type.tostring(): type,
      PetEnum.size.tostring(): size,
      PetEnum.name.tostring(): name,
      PetEnum.city.tostring(): city,
      PetEnum.kind.tostring(): kind,
      PetEnum.uid.tostring(): uid,
    };
  }
}
