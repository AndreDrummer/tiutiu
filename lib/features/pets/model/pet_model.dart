import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/models/post.dart';
import 'package:uuid/uuid.dart';

enum PetEnum {
  otherCaracteristics,
  chronicDiseaseInfo,
  lastSeenDetails,
  storageHashKey,
  donatedOrFound,
  disappeared,
  ageMonth,
  ageYear,
  gender,
  health,
  color,
  breed,
  size,
}

class Pet extends Post {
  Pet({
    this.otherCaracteristics = const [],
    this.chronicDiseaseInfo = '',
    String describedAddress = '',
    this.donatedOrFound = false,
    this.lastSeenDetails = '',
    String city = 'Acrelândia',
    this.disappeared = false,
    String description = '',
    List photos = const [],
    int interesteds = 0,
    this.storageHashKey,
    String state = 'Acre',
    String? createdAt,
    double? longitude,
    this.ageMonth = 0,
    String type = '-',
    this.gender = '-',
    TiutiuUser? owner,
    this.health = '-',
    this.ageYear = 0,
    double? latitude,
    this.color = '-',
    this.breed = '-',
    this.size = '-',
    String? ownerId,
    int views = 0,
    dynamic video,
    String? name,
    String? uid,
  }) : super(
          describedAddress: describedAddress,
          description: description,
          interesteds: interesteds,
          hidden: donatedOrFound,
          longitude: longitude,
          done: donatedOrFound,
          createdAt: createdAt,
          latitude: latitude,
          ownerId: ownerId,
          photos: photos,
          state: state,
          views: views,
          owner: owner,
          video: video,
          city: city,
          type: type,
          name: name,
          uid: uid,
        );

  @override
  Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      createdAt: map[PostEnum.createdAt.name] ?? DateTime.now().toIso8601String(),
      uid: map[PostEnum.uid.name] != null ? map[PostEnum.uid.name] : Uuid().v4(),
      otherCaracteristics: map[PetEnum.otherCaracteristics.name] ?? [],
      chronicDiseaseInfo: map[PetEnum.chronicDiseaseInfo.name] ?? '',
      describedAddress: map[PostEnum.describedAddress.name] ?? '',
      donatedOrFound: map[PetEnum.donatedOrFound.name] ?? false,
      lastSeenDetails: map[PetEnum.lastSeenDetails.name] ?? '',
      owner: TiutiuUser.fromMap(map[PostEnum.owner.name]),
      storageHashKey: map[PetEnum.storageHashKey.name],
      description: map[PostEnum.description.name] ?? '',
      city: map[PostEnum.city.name] ?? 'Acrelândia',
      disappeared: map[PetEnum.disappeared.name],
      interesteds: map[PostEnum.interesteds.name],
      state: map[PostEnum.state.name] ?? 'Acre',
      health: map[PetEnum.health.name] ?? '-',
      gender: map[PetEnum.gender.name] ?? '-',
      longitude: map[PostEnum.longitude.name],
      color: map[PetEnum.color.name] ?? '-',
      breed: map[PetEnum.breed.name] ?? '-',
      latitude: map[PostEnum.latitude.name],
      views: map[PostEnum.views.name] ?? 0,
      ageMonth: map[PetEnum.ageMonth.name],
      size: map[PetEnum.size.name] ?? '-',
      type: map[PostEnum.type.name] ?? '-',
      ownerId: map[PostEnum.ownerId.name],
      ageYear: map[PetEnum.ageYear.name],
      photos: map[PostEnum.photos.name],
      video: map[PostEnum.video.name],
      name: map[PostEnum.name.name],
    );
  }

  String chronicDiseaseInfo;
  List otherCaracteristics;
  String lastSeenDetails;
  String? storageHashKey;
  bool donatedOrFound;
  bool disappeared;
  String gender;
  String health;
  int? ageMonth;
  String breed;
  int? ageYear;
  String color;
  String size;

  @override
  Map<String, dynamic> toMap({bool convertFileToVideoPath = false}) {
    return {
      PostEnum.photos.name: convertFileToVideoPath ? photos.map((e) => e.path).toList() : photos,
      PostEnum.video.name: convertFileToVideoPath ? video.path : video,
      PetEnum.otherCaracteristics.name: otherCaracteristics,
      PetEnum.chronicDiseaseInfo.name: chronicDiseaseInfo,
      PostEnum.describedAddress.name: describedAddress,
      PetEnum.lastSeenDetails.name: lastSeenDetails,
      PetEnum.donatedOrFound.name: donatedOrFound,
      PetEnum.storageHashKey.name: storageHashKey,
      PostEnum.interesteds.name: interesteds,
      PostEnum.description.name: description,
      PetEnum.disappeared.name: disappeared,
      PostEnum.owner.name: owner?.toMap(),
      PostEnum.longitude.name: longitude,
      PostEnum.createdAt.name: createdAt,
      PostEnum.latitude.name: latitude,
      PetEnum.ageMonth.name: ageMonth,
      PostEnum.ownerId.name: ownerId,
      PetEnum.ageYear.name: ageYear,
      PetEnum.health.name: health,
      PetEnum.gender.name: gender,
      PostEnum.state.name: state,
      PostEnum.views.name: views,
      PetEnum.color.name: color,
      PetEnum.breed.name: breed,
      PostEnum.type.name: type,
      PostEnum.name.name: name,
      PostEnum.city.name: city,
      PetEnum.size.name: size,
      PostEnum.uid.name: uid,
    };
  }

  @override
  String toString() {
    return 'Pet(otherCaracteristics: $otherCaracteristics, chronicDiseaseInfo: $chronicDiseaseInfo, lastSeenDetails: $lastSeenDetails, storageHashKey: $storageHashKey, donatedOrFound: $donatedOrFound, createdAt: $createdAt, owner: $owner, longitude: $longitude, disappeared: $disappeared, latitude: $latitude, ownerId: $ownerId, interesteds: $interesteds, description: $description, gender: $gender, health: $health, color: $color, ageMonth: $ageMonth, breed: $breed, ageYear: $ageYear, size: $size, state: $state, photos: $photos, name: $name, type: $type, city: $city, uid: $uid, views: $views, video: $video)';
  }

  @override
  bool operator ==(covariant Pet other) {
    if (identical(this, other)) return true;

    return other.otherCaracteristics == otherCaracteristics &&
        other.chronicDiseaseInfo == chronicDiseaseInfo &&
        other.describedAddress == describedAddress &&
        other.lastSeenDetails == lastSeenDetails &&
        other.storageHashKey == storageHashKey &&
        other.donatedOrFound == donatedOrFound &&
        other.disappeared == disappeared &&
        other.interesteds == interesteds &&
        other.description == description &&
        other.longitude == longitude &&
        other.createdAt == createdAt &&
        other.latitude == latitude &&
        other.ageMonth == ageMonth &&
        other.ownerId == ownerId &&
        other.ageYear == ageYear &&
        other.gender == gender &&
        other.health == health &&
        other.photos == photos &&
        other.owner == owner &&
        other.video == video &&
        other.color == color &&
        other.breed == breed &&
        other.views == views &&
        other.state == state &&
        other.name == name &&
        other.size == size &&
        other.type == type &&
        other.city == city &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return otherCaracteristics.hashCode ^
        chronicDiseaseInfo.hashCode ^
        describedAddress.hashCode ^
        lastSeenDetails.hashCode ^
        storageHashKey.hashCode ^
        donatedOrFound.hashCode ^
        interesteds.hashCode ^
        description.hashCode ^
        disappeared.hashCode ^
        createdAt.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        ageMonth.hashCode ^
        ownerId.hashCode ^
        ageYear.hashCode ^
        gender.hashCode ^
        photos.hashCode ^
        health.hashCode ^
        owner.hashCode ^
        video.hashCode ^
        color.hashCode ^
        breed.hashCode ^
        views.hashCode ^
        state.hashCode ^
        size.hashCode ^
        name.hashCode ^
        type.hashCode ^
        city.hashCode ^
        uid.hashCode;
  }
}
