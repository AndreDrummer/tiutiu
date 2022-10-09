import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';

enum PetEnum {
  otherCaracteristics,
  lastSeenDetails,
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
  city,
  uid,
}

class Pet {
  Pet({
    this.donatedOrFound = false,
    this.lastSeenDetails = '',
    this.disappeared = false,
    this.otherCaracteristics,
    this.city = 'Acrelândia',
    this.state = 'Acre',
    this.interesteds = 0,
    this.storageHashKey,
    this.ageMonth = 0,
    this.ageYear = 0,
    this.longitude,
    this.createdAt,
    this.latitude,
    this.details,
    this.photos,
    this.ownerId,
    this.health,
    this.gender,
    this.color,
    this.views,
    this.breed,
    this.type,
    this.owner,
    this.size,
    this.name,
    this.uid,
  });

  static Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      otherCaracteristics: map[PetEnum.otherCaracteristics.name],
      donatedOrFound: map[PetEnum.donatedOrFound.name] ?? false,
      lastSeenDetails: map[PetEnum.lastSeenDetails.name] ?? '',
      owner: TiutiuUser.fromMap(map[PetEnum.owner.name]),
      storageHashKey: map[PetEnum.storageHashKey.name],
      city: map[PetEnum.city.name] ?? 'Acrelândia',
      disappeared: map[PetEnum.disappeared.name],
      interesteds: map[PetEnum.interesteds.name],
      state: map[PetEnum.state.name] ?? 'Acre',
      longitude: map[PetEnum.longitude.name],
      createdAt: map[PetEnum.createdAt.name],
      latitude: map[PetEnum.latitude.name],
      ageMonth: map[PetEnum.ageMonth.name],
      details: map[PetEnum.details.name],
      ownerId: map[PetEnum.ownerId.name],
      ageYear: map[PetEnum.ageYear.name],
      photos: map[PetEnum.photos.name],
      health: map[PetEnum.health.name],
      gender: map[PetEnum.gender.name],
      color: map[PetEnum.color.name],
      views: map[PetEnum.views.name],
      breed: map[PetEnum.breed.name],
      type: map[PetEnum.type.name],
      size: map[PetEnum.size.name],
      name: map[PetEnum.name.name],
      uid: map[PetEnum.uid.name],
    );
  }

  static Pet fromMigrate(Map<String, dynamic> map) {
    return Pet(
      otherCaracteristics: map[PetEnum.otherCaracteristics.name],
      donatedOrFound: map['donated'] ?? map['found'] ?? false,
      owner: TiutiuUser.fromMap(map[PetEnum.owner.name]),
      storageHashKey: map[PetEnum.storageHashKey.name],
      longitude: map[PetEnum.longitude.name],
      createdAt: map[PetEnum.createdAt.name],
      latitude: map[PetEnum.latitude.name],
      ownerId: map['ownerId'],
      ageMonth: map['meses'],
      details: map[PetEnum.details.name],
      ageYear: map['ano'],
      photos: map[PetEnum.photos.name],
      health: map[PetEnum.health.name],
      gender: map['sex'],
      color: map[PetEnum.color.name],
      views: map[PetEnum.views.name],
      breed: map[PetEnum.breed.name],
      type: map[PetEnum.type.name],
      size: map[PetEnum.size.name],
      name: map[PetEnum.name.name],
      city: map[PetEnum.city.name],
      uid: map[PetEnum.uid.name],
    );
  }

  List? otherCaracteristics;
  String lastSeenDetails;
  String? storageHashKey;
  bool donatedOrFound;
  String? createdAt;
  TiutiuUser? owner;
  double? longitude;
  bool disappeared;
  double? latitude;
  String? ownerId;
  int interesteds;
  String? details;
  String? gender;
  String? health;
  String state;
  String? color;
  int? ageMonth;
  String? breed;
  int? ageYear;
  String? size;
  String? type;
  String city;
  List? photos;
  String? name;
  String? uid;
  int? views;

  Map<String, dynamic> toMap() {
    return {
      PetEnum.otherCaracteristics.name: otherCaracteristics,
      PetEnum.lastSeenDetails.name: lastSeenDetails,
      PetEnum.donatedOrFound.name: donatedOrFound,
      PetEnum.storageHashKey.name: storageHashKey,
      PetEnum.disappeared.name: disappeared,
      PetEnum.interesteds.name: interesteds,
      PetEnum.owner.name: owner?.toMap(),
      PetEnum.longitude.name: longitude,
      PetEnum.createdAt.name: createdAt,
      PetEnum.latitude.name: latitude,
      PetEnum.ageMonth.name: ageMonth,
      PetEnum.details.name: details,
      PetEnum.ownerId.name: ownerId,
      PetEnum.ageYear.name: ageYear,
      PetEnum.photos.name: photos,
      PetEnum.health.name: health,
      PetEnum.gender.name: gender,
      PetEnum.state.name: state,
      PetEnum.color.name: color,
      PetEnum.views.name: views,
      PetEnum.breed.name: breed,
      PetEnum.type.name: type,
      PetEnum.size.name: size,
      PetEnum.name.name: name,
      PetEnum.city.name: city,
      PetEnum.uid.name: uid,
    };
  }
}
