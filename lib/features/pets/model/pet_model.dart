import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';

enum PetEnum {
  otherCaracteristics,
  chronicDiseaseInfo,
  lastSeenDetails,
  describedAdress,
  storageHashKey,
  donatedOrFound,
  description,
  interesteds,
  disappeared,
  createdAt,
  longitude,
  latitude,
  ageMonth,
  ownerId,
  ageYear,
  gender,
  health,
  photos,
  owner,
  color,
  breed,
  state,
  views,
  size,
  name,
  type,
  city,
  uid,
}

class Pet {
  Pet({
    this.otherCaracteristics = const [],
    this.chronicDiseaseInfo = '',
    this.donatedOrFound = false,
    this.lastSeenDetails = '',
    this.describedAdress = '',
    this.disappeared = false,
    this.city = 'Acrelândia',
    this.photos = const [],
    this.interesteds = 0,
    this.storageHashKey,
    this.state = 'Acre',
    this.ageMonth = 0,
    this.gender = '-',
    this.health = '-',
    this.ageYear = 0,
    this.description,
    this.color = '-',
    this.breed = '-',
    this.type = '-',
    this.size = '-',
    this.longitude,
    this.createdAt,
    this.latitude,
    this.ownerId,
    this.views,
    this.owner,
    this.name,
    this.uid,
  });

  static Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      chronicDiseaseInfo: map[PetEnum.chronicDiseaseInfo.name] ?? '',
      otherCaracteristics: map[PetEnum.otherCaracteristics.name],
      donatedOrFound: map[PetEnum.donatedOrFound.name] ?? false,
      lastSeenDetails: map[PetEnum.lastSeenDetails.name] ?? '',
      describedAdress: map[PetEnum.describedAdress.name] ?? '',
      owner: TiutiuUser.fromMap(map[PetEnum.owner.name]),
      storageHashKey: map[PetEnum.storageHashKey.name],
      city: map[PetEnum.city.name] ?? 'Acrelândia',
      disappeared: map[PetEnum.disappeared.name],
      interesteds: map[PetEnum.interesteds.name],
      description: map[PetEnum.description.name],
      state: map[PetEnum.state.name] ?? 'Acre',
      health: map[PetEnum.health.name] ?? '-',
      gender: map[PetEnum.gender.name] ?? '-',
      longitude: map[PetEnum.longitude.name],
      createdAt: map[PetEnum.createdAt.name],
      color: map[PetEnum.color.name] ?? '-',
      breed: map[PetEnum.breed.name] ?? '-',
      latitude: map[PetEnum.latitude.name],
      ageMonth: map[PetEnum.ageMonth.name],
      size: map[PetEnum.size.name] ?? '-',
      type: map[PetEnum.type.name] ?? '-',
      ownerId: map[PetEnum.ownerId.name],
      ageYear: map[PetEnum.ageYear.name],
      photos: map[PetEnum.photos.name],
      views: map[PetEnum.views.name],
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
      description: map[PetEnum.description.name],
      longitude: map[PetEnum.longitude.name],
      createdAt: map[PetEnum.createdAt.name],
      latitude: map[PetEnum.latitude.name],
      photos: map[PetEnum.photos.name],
      health: map[PetEnum.health.name],
      color: map[PetEnum.color.name],
      views: map[PetEnum.views.name],
      breed: map[PetEnum.breed.name],
      type: map[PetEnum.type.name],
      size: map[PetEnum.size.name],
      name: map[PetEnum.name.name],
      city: map[PetEnum.city.name],
      uid: map[PetEnum.uid.name],
      ownerId: map['ownerId'],
      ageMonth: map['meses'],
      ageYear: map['ano'],
      gender: map['sex'],
    );
  }

  String chronicDiseaseInfo;
  List otherCaracteristics;
  String? storageHashKey;
  String lastSeenDetails;
  String describedAdress;
  bool donatedOrFound;
  String? description;
  String? createdAt;
  TiutiuUser? owner;
  double? longitude;
  bool disappeared;
  double? latitude;
  String? ownerId;
  int interesteds;
  String gender;
  String health;
  String color;
  int? ageMonth;
  String breed;
  int? ageYear;
  String size;
  String state;
  List photos;
  String? name;
  String type;
  String city;
  String? uid;
  int? views;

  Map<String, dynamic> toMap() {
    return {
      PetEnum.otherCaracteristics.name: otherCaracteristics,
      PetEnum.chronicDiseaseInfo.name: chronicDiseaseInfo,
      PetEnum.lastSeenDetails.name: lastSeenDetails,
      PetEnum.donatedOrFound.name: donatedOrFound,
      PetEnum.storageHashKey.name: storageHashKey,
      PetEnum.disappeared.name: disappeared,
      PetEnum.description.name: description,
      PetEnum.interesteds.name: interesteds,
      PetEnum.owner.name: owner?.toMap(),
      PetEnum.longitude.name: longitude,
      PetEnum.createdAt.name: createdAt,
      PetEnum.latitude.name: latitude,
      PetEnum.ageMonth.name: ageMonth,
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

  @override
  String toString() {
    return 'Pet(otherCaracteristics: $otherCaracteristics, chronicDiseaseInfo: $chronicDiseaseInfo, lastSeenDetails: $lastSeenDetails, storageHashKey: $storageHashKey, donatedOrFound: $donatedOrFound, createdAt: $createdAt, owner: $owner, longitude: $longitude, disappeared: $disappeared, latitude: $latitude, ownerId: $ownerId, interesteds: $interesteds, description: $description, gender: $gender, health: $health, color: $color, ageMonth: $ageMonth, breed: $breed, ageYear: $ageYear, size: $size, state: $state, photos: $photos, name: $name, type: $type, city: $city, uid: $uid, views: $views)';
  }

  @override
  bool operator ==(covariant Pet other) {
    if (identical(this, other)) return true;

    return other.otherCaracteristics == otherCaracteristics &&
        other.chronicDiseaseInfo == chronicDiseaseInfo &&
        other.describedAdress == describedAdress &&
        other.lastSeenDetails == lastSeenDetails &&
        other.storageHashKey == storageHashKey &&
        other.donatedOrFound == donatedOrFound &&
        other.createdAt == createdAt &&
        other.owner == owner &&
        other.longitude == longitude &&
        other.disappeared == disappeared &&
        other.latitude == latitude &&
        other.ownerId == ownerId &&
        other.interesteds == interesteds &&
        other.description == description &&
        other.gender == gender &&
        other.health == health &&
        other.color == color &&
        other.ageMonth == ageMonth &&
        other.breed == breed &&
        other.ageYear == ageYear &&
        other.size == size &&
        other.state == state &&
        other.photos == photos &&
        other.name == name &&
        other.type == type &&
        other.city == city &&
        other.uid == uid &&
        other.views == views;
  }

  @override
  int get hashCode {
    return otherCaracteristics.hashCode ^
        lastSeenDetails.hashCode ^
        storageHashKey.hashCode ^
        chronicDiseaseInfo.hashCode ^
        describedAdress.hashCode ^
        donatedOrFound.hashCode ^
        createdAt.hashCode ^
        owner.hashCode ^
        longitude.hashCode ^
        disappeared.hashCode ^
        latitude.hashCode ^
        ownerId.hashCode ^
        interesteds.hashCode ^
        description.hashCode ^
        gender.hashCode ^
        health.hashCode ^
        color.hashCode ^
        ageMonth.hashCode ^
        breed.hashCode ^
        ageYear.hashCode ^
        size.hashCode ^
        state.hashCode ^
        photos.hashCode ^
        name.hashCode ^
        type.hashCode ^
        city.hashCode ^
        uid.hashCode ^
        views.hashCode;
  }
}
